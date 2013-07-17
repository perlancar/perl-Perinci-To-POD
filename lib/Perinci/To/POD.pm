package Perinci::To::POD;

use 5.010001;
use Log::Any '$log';
use Moo;

extends 'Perinci::To::PackageBase';

# VERSION

sub BUILD {
    my ($self, $args) = @_;
}

sub _md2pod {
    require Markdown::Pod;

    my ($self, $md) = @_;
    state $m2p = Markdown::Pod->new;
    $m2p->markdown_to_pod(markdown => $md);
}

sub doc_gen_summary {
    my ($self) = @_;

    my $name_summary = join(
        "",
        $self->doc_parse->{name} // "",
        ($self->doc_parse->{name} && $self->doc_parse->{summary} ? ' - ' : ''),
        $self->doc_parse->{summary} // ""
    );

    $self->add_doc_lines(
        "=head1 " . uc($self->loc("Name")),
        "",
        $name_summary,
        "",
    );
}

sub doc_gen_version {
    my ($self) = @_;

    $self->add_doc_lines(
        "=head1 " . uc($self->loc("Version")),
        "",
        $self->{_meta}{entity_version} // '?',
        "",
    );
}

sub doc_gen_description {
    my ($self) = @_;

    $self->add_doc_lines(
        "=head1 " . uc($self->loc("Description")),
        ""
    );

    if ($self->doc_parse->{description}) {
        $self->add_doc_lines(
            $self->_md2pod($self->doc_parse->{description}),
            "",
        );
    }

    #$self->add_doc_lines(
    #    $self->loc("This module has L<Rinci> metadata") . ".",
    #    "",
    #);
}

sub _fdoc_gen {
    my ($self, $url) = @_;
    my $p = $self->doc_parse->{functions}{$url};

    my $has_args = !!keys(%{$p->{args}});

    $self->add_doc_lines(
        "=head2 " . $p->{name} .
            ($has_args ? $p->{perl_args} : "()"). ' -> ' . $p->{human_ret},
        "");

    $self->add_doc_lines($p->{summary} . ($p->{summary} =~ /\.$/ ? "":"."), "")
        if $p->{summary};
    $self->add_doc_lines($self->_md2pod($p->{description}), "")
        if $p->{description};

    my $feat = $p->{meta}{features} // {};
    my @ft;
    my %spargs;
    if ($feat->{reverse}) {
        push @ft, $self->loc("This function supports reverse operation.");
        $spargs{-reverse} = {
            type => 'bool',
            summary => $self->loc("Pass -reverse=>1 to reverse operation."),
        };
    }
    if ($feat->{undo}) {
        push @ft, $self->loc("This function supports undo operation.");
        $spargs{-undo_action} = {
            type => 'str',
            summary => $self->loc(join(
                "",
                "To undo, pass -undo_action=>'undo' to function. ",
                "You will also need to pass -undo_data. ",
                "For more details on undo protocol, ",
                "see L<Rinci::Undo>.")),
        };
        $spargs{-undo_data} = {
            type => 'array',
            summary => $self->loc(join(
                "",
                "Required if you pass -undo_action=>'undo'. ",
                "For more details on undo protocol, ",
                "see L<Rinci::function::Undo>.")),
        };
    }
    if ($feat->{dry_run}) {
        push @ft, $self->loc("This function supports dry-run operation.");
        $spargs{-dry_run} = {
            type => 'bool',
            summary=>$self->loc("Pass -dry_run=>1 to enable simulation mode."),
        };
    }
    push @ft, $self->loc("This function is pure (produce no side effects).")
        if $feat->{pure};
    push @ft, $self->loc("This function is immutable (returns same result ".
                             "for same arguments).")
        if $feat->{immutable};
    push @ft, $self->loc("This function is idempotent (repeated invocations ".
                             "with same arguments has the same effect as ".
                                 "single invocation).")
        if $feat->{idempotent};
    if ($feat->{tx}) {
        die "Sorry, I only support transaction protocol v=2"
            unless $feat->{tx}{v} == 2;
        push @ft, $self->loc("This function supports transactions.");
        $spargs{$_} = {
            type => 'str',
            summary => $self->loc(join(
                "",
                "For more information on transaction, see ",
                "L<Rinci::Transaction>.")),
        } for qw(-tx_action -tx_action_id -tx_v -tx_rollback -tx_recovery),
    }
    $self->add_doc_lines(join(" ", @ft), "", "") if @ft;

    if ($has_args) {
        $self->add_doc_lines(
            $self->loc("Arguments") .
                ' (' . $self->loc("'*' denotes required arguments") . '):',
            "",
            "=over 4",
            "",
        );
        for my $name (sort keys %{$p->{args}}) {
            my $pa = $p->{args}{$name};
            $self->add_doc_lines(join(
                "",
                "=item * B<", $name, ">",
                ($pa->{req} ? '*' : ''), ' => ',
                "I<", $pa->{human_arg}, ">",
                (defined($pa->{human_arg_default}) ?
                     " (" . $self->loc("default") .
                         ": $pa->{human_arg_default})" : "")
            ), "");
            $self->add_doc_lines(
                $pa->{summary} . ($pa->{summary} =~ /\.$/ ? "" : "."),
                "") if $pa->{summary};
            $self->add_doc_lines(
                $self->_md2pod($pa->{description}),
                "") if $pa->{description};
        }
        $self->add_doc_lines("=back", "");
    } else {
        $self->add_doc_lines($self->loc("No arguments") . ".", "");
    }

    if (keys %spargs) {
        $self->add_doc_lines(
            $self->loc("Special arguments") . ":",
            "",
            "=over 4",
            "",
        );
        for my $name (sort keys %spargs) {
            my $spa = $spargs{$name};
            $self->add_doc_lines(join(
                "",
                "=item * B<", $name, ">",
                ' => ',
                "I<", $spa->{type}, ">",
                (defined($spa->{default}) ?
                     " (" . $self->loc("default") .
                         ": $spa->{default})" : "")
            ), "");
            $self->add_doc_lines(
                $spa->{summary} . ($spa->{summary} =~ /\.$/ ? "" : "."),
                "") if $spa->{summary};
        }
        $self->add_doc_lines("=back", "");
    }

    $self->add_doc_lines($self->loc("Return value") . ':', "");
    my $rn = $p->{orig_meta}{result_naked} // $p->{meta}{result_naked};
    $self->add_doc_lines($self->_md2pod($self->loc(join(
        "",
        "Returns an enveloped result (an array). ",
        "First element (status) is an integer containing HTTP status code ",
        "(200 means OK, 4xx caller error, 5xx function error). Second element ",
        "(msg) is a string containing error message, or 'OK' if status is ",
        "200. Third element (result) is optional, the actual result. Fourth ",
        "element (meta) is called result metadata and is optional, a hash ",
        "that contains extra information."))), "")
        unless $rn;

    # XXX result summary

    # XXX result description

    # test
    #$self->add_doc_lines({wrap=>0}, "Line 1\nLine 2\n");
}

sub doc_gen_functions {
    my ($self) = @_;
    my $pff = $self->doc_parse->{functions};

    $self->add_doc_lines(
        "=head1 " . uc($self->loc("Functions")),
        "",
    );

    # temporary, since we don't parse export information yet (and
    # Perinci::Exporter is not yet written anyway)
    $self->add_doc_lines(
        $self->loc("None are exported by default, but they are exportable."),
        "",
    );

    # XXX if module uses Perinci::Exporter, show a basic usage for importing

    # XXX categorize functions based on tags
    for my $url (sort keys %$pff) {
        my $p = $pff->{$url};
        $self->_fdoc_gen($url);
    }

}

1;
# ABSTRACT: Generate POD documentation from Rinci package metadata

=for Pod::Coverage .+

=head1 SYNOPSIS

You can use the included L<peri-pod> script, or:

 use Perinci::To::POD;

 # to generate POD for the whole module
 my $doc = Perinci::To::POD->new(url => "/Some/Module/");
 say $doc->generate_doc;

 # to generate POD for a certain function only, currently you can parse/cut the
 # whole module POD by yourself.

=cut

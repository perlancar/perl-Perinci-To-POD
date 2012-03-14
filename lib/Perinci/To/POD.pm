package Perinci::To::POD;

use 5.010;
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

sub gen_summary {
    my ($self) = @_;

    my $name_summary = join(
        "",
        $self->_parse->{name} // "",
        ($self->_parse->{name} && $self->_parse->{summary} ? ' - ' : ''),
        $self->_parse->{summary} // ""
    );

    $self->add_lines(
        "=head1 " . uc($self->loc("Name")),
        "",
        $name_summary,
        "",
    );
}

sub gen_version {
    my ($self) = @_;

    $self->add_lines(
        "=head1 " . uc($self->loc("Version")),
        "",
        $self->{_meta}{pkg_version} // '?',
        "",
    );
}

sub gen_description {
    my ($self) = @_;

    return unless $self->_parse->{description};

    $self->add_lines(
        "=head1 " . uc($self->loc("Description")),
        "",
        $self->_md2pod($self->_parse->{description}),
        "",
    );
}

sub _gen_function {
    my ($self, $url) = @_;
    my $p = $self->_parse->{functions}{$url};

    my $has_args = !!keys(%{$p->{args}});

    $self->add_lines(
        "=head2 " . $p->{name} .
            ($has_args ? $p->{perl_args} : "()"). ' -> ' . $p->{human_ret},
        "");

    $self->add_lines($p->{summary} . ($p->{summary} =~ /\.$/ ? "" : "."), "")
        if $p->{summary};
    $self->add_lines($self->_md2pod($p->{description}), "")
        if $p->{description};
    if ($has_args) {
        $self->add_lines(
            $self->loc("Arguments") .
                ' (' . $self->loc("'*' denotes required arguments") . '):',
            "",
            "=over 4",
            "",
        );
        for my $name (sort keys %{$p->{args}}) {
            my $pa = $p->{args}{$name};
            $self->add_lines(join(
                "",
                "=item * B<", $name, ">",
                ($pa->{schema}[1]{req} ? '*' : ''), ' => ',
                "I<", $pa->{human_arg}, ">",
                (defined($pa->{human_arg_default}) ?
                     " (" . $self->loc("default") .
                         ": $pa->{human_arg_default})" : "")
            ), "");
            $self->add_lines(
                $pa->{summary} . ($p->{summary} =~ /\.$/ ? "" : "."),
                "") if $pa->{summary};
            $self->add_lines(
                $self->_md2pod($pa->{description}),
                "") if $pa->{description};
        }
        $self->add_lines("=back", "");
    } else {
        $self->add_lines($self->loc("No arguments") . ".", "");
    }
    $self->add_lines($self->loc("Return value") . ':', "");
    $self->add_lines($self->_md2pod($self->loc(join(
        "",
        "Returns an enveloped result (an array). ",
        "First element (status) is an integer containing HTTP status code ",
        "(200 means OK, 4xx caller error, 5xx function error). Second element ",
        "(msg) is a string containing error message, or 'OK' if status is ",
        "200. Third element (result) is optional, the actual result. Fourth ",
        "element (meta) is called result metadata and is optional, a hash ",
        "that contains extra information."))), "")
        unless $p->{schema}{result_naked};

    # XXX result summary

    # XXX result description

    # test
    #$self->add_lines({wrap=>0}, "Line 1\nLine 2\n");
}

sub gen_functions {
    my ($self) = @_;
    my $pff = $self->_parse->{functions};

    $self->add_lines(
        "=head1 " . uc($self->loc("Functions")),
        "",
    );

    # XXX categorize functions based on tags
    for my $url (sort keys %$pff) {
        my $p = $pff->{$url};
        $self->_gen_function($url);
    }

}

1;
# ABSTRACT: Generate POD documentation from Rinci package metadata

=cut

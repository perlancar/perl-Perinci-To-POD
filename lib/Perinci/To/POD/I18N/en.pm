package Perinci::To::POD::I18N::en;
use parent qw(Perinci::To::POD::I18N Perinci::To::PackageBase::I18N::en);

use Locale::Maketext::Lexicon::Gettext;
our %Lexicon = %{ Locale::Maketext::Lexicon::Gettext->parse(<DATA>) };

# VERSION

#use Data::Dump; dd \%Lexicon;

1;
# ABSTRACT: English translation for Perinci::To::POD
__DATA__

msgid  "This module has L<Rinci> metadata"
msgstr "This module has L<Rinci> metadata"

msgid  "No arguments"
msgstr "No arguments"

# function

msgid  "None are exported by default, but they are exportable."
msgstr "None are exported by default, but they are exportable."

# function's special arguments

msgid  "Pass -reverse=>1 to reverse operation."
msgstr "Pass -reverse=>1 to reverse operation."

msgid  "To undo, pass -undo_action=>'undo' to function. You will also need to pass -undo_data. For more details on undo protocol, see L<Rinci::Undo>."
msgstr "To undo, pass -undo_action=>'undo' to function. You will also need to pass -undo_data. For more details on undo protocol, see L<Rinci::Undo>."

msgid  "Required if you pass -undo_action=>'undo'. For more details on undo protocol, see L<Rinci::Undo>."
msgstr "Required if you pass -undo_action=>'undo'. For more details on undo protocol, see L<Rinci::Undo>."

msgid  "Pass -dry_run=>1 to enable simulation mode."
msgstr "Pass -dry_run=>1 to enable simulation mode."

msgid  "This function supports transactions."
msgstr "This function supports transactions."

msgid  "For more information on transaction, see L<Rinci::Transaction>."
msgstr "For more information on transaction, see L<Rinci::Transaction>."

package Perinci::To::DocBase::I18N::en;
use base 'Perinci::To::DocBase::I18N';

use Locale::Maketext::Lexicon::Gettext;
our %Lexicon = %{ Locale::Maketext::Lexicon::Gettext->parse(<DATA>) };

#use Data::Dump; dd \%Lexicon;

1;
# ABSTRACT: English translation for Perinci::To::* document generators
__DATA__
msgid  "Functions"
msgstr "Functions"

msgid  "Variables"
msgstr "Variables"

msgid  "Summary"
msgstr "Summary"

msgid  "Description"
msgstr "Description"

msgid  "Examples"
msgstr "Examples"

msgid  "See Also"
msgstr "See Also"

msgid  "Links"
msgstr "Links"

msgid  "Tags"
msgstr "Tags"

msgid  "Categories"
msgstr "Categories"

msgid  "Category"
msgstr "Category"

### Text::Usage
msgid  "Show version"
msgstr "Show version"

msgid  "Display this help message"
msgstr "Display this help message"

msgid  "List available subcommands"
msgstr "List available subcommands"

### POD

msgid  "This module has L<Rinci> metadata"
msgid  "This module has L<Rinci> metadata"

# tmp: Sah
msgid  "default"
msgstr "default"

msgid  "value in"
msgstr "value in"

msgid  "required"
msgstr "required"

msgid  "optional"
msgstr "optional"

msgid  "minimum"
msgstr "minimum"

msgid  "maximum"
msgstr "maximum"

msgid  "less than"
msgstr "less than"

msgid  "greater than"
msgstr "greater than"

msgid  "between %1 and %2"
msgstr "between %1 and %2"

msgid  "between %1 and %2 (exclusive)"
msgstr "between %1 and %2 (exclusive)"

# function

msgid  "Arguments"
msgstr "Arguments"

msgid  "'*' denotes required arguments"
msgstr "'*' denotes required arguments"

msgid  "Result"
msgstr "Result"

msgid  "Return value"
msgstr "Return value"

msgid  "Returns an enveloped result (an array). First element ($status) is HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element ($msg) is error message, or 'OK' if status is 200. Third element ($result) is the actual result. Fourth element ($meta) is called result metadata and is optional, hash that contains extra information."
msgid  "Returns an enveloped result (an array). First element ($status) is HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element ($msg) is error message, or 'OK' if status is 200. Third element ($result) is the actual result. Fourth element ($meta) is called result metadata and is optional, hash that contains extra information."

### function/Text::Usage

msgid  "or as argument #%1"
msgstr "or as argument #%1"

### function/POD

msgid  "None are exported by default, but they are exportable."
msgstr "None are exported by default, but they are exportable."

# function features

msgid  "This function supports todo operation. Please read 'The undo protocol' in Rinci::function specification."
msgstr "This function supports todo operation. Please read 'The undo protocol' in Rinci::function specification."

msgid  "This function is declared as %1 (%2). Please read the '%1' feature in Rinci::function specification."
msgid  "This function is declared as %1 (%2). Please read the '%1' feature in Rinci::function specification."


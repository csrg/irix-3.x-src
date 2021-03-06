'\"macro stdmacro
.ds P UniPlus\s-2\v'-.3v'+\v'.3v'\s0
.TH INTRO 1M
.SH NAME
intro \- introduction to system maintenance commands and application programs
.SH DESCRIPTION
This section describes, in alphabetical order, commands
that are used chiefly for system maintenance and administration purposes.
The commands in this section should be used along with those
listed in Section 1 of the
.IR "\*P User's Manual" .
References to other manual entries not of the form
.IR name (1M),
.IR name (7)
or
.IR name (8)
refer to entries of that manual.
.SH COMMAND SYNTAX
Unless otherwise noted, commands described in this section accept options and
other arguments according to the following syntax:
.PP
.I name
.RI [ option ( s )]
.RI [ cmdarg ( s )]
.br
where:
.TP 13
.I name
The name of an executable file.
.TP
.I option\^
.B \-
.IR noargletter ( s )     
or,
.br
.B \-
.IR argletter <> optarg
.br
where <> is optional white space.
.TP
.I noargletter\^
A single letter representing an option without an argument.
.TP
.I argletter\^
A single letter representing an option requiring an argument.
.TP
.I optarg\^
Argument (character string) satisfying preceding
.IR argletter .
.TP
.I cmdarg\^
Path name (or other command argument)
.I not\^
beginning with
.B \-
or,
.B \-
by itself indicating the standard input.
.SH SEE ALSO
getopt(1), getopt(3C).
.br
.IR "\*P User's Manual" .
.br
.IR "\*P Administrator's Guide" .
.SH DIAGNOSTICS
Upon termination, each command returns two bytes of status,
one supplied by the system and giving the cause for
termination, and (in the case of ``normal'' termination)
one supplied by the program
(see
.IR wait (2)
and
.IR exit (2)).
The former byte is 0 for normal termination; the latter
is customarily 0 for successful execution and non-zero
to indicate troubles such as erroneous parameters, bad or inaccessible data,
or other inability to cope with the task at hand.
It is called variously ``exit code'', ``exit status'', or
``return code'', and is described only where special
conventions are involved.
.SH BUGS
Regretfully, many commands do not adhere to the aforementioned syntax.
.\"	@(#)intro.1m	5.1 of 10/17/83

(*****************************************************************************)
(*                                                                           *)
(*                            File: FLIBSTOP.TEXT                            *)
(*                                                                           *)
(*           (C) Copyright 1982, 1985 Silicon Valley Software, Inc.          *)
(*                                                                           *)
(*                            All Rights Reserved.               10-May-85   *)
(*                                                                           *)
(*****************************************************************************)


{$%+} {$R-} {$I-}

unit %flibstop;

interface

uses {$U flibinit} %flibinit;

implementation

procedure %_stop(s: ppac; len: longint);
  var i: integer;
begin
writeln;
write(' Programmed STOP ');
for i := 1 to len do
    write(s^[i]);
writeln;
%_rtsfin; halt(OKHALT);
end; {%_stop}

procedure %_pause(s: ppac; len: longint);
  var i: integer; ch: char;
begin
writeln;
write(' Programmed PAUSE ');
for i := 1 to len do
    write(s^[i]);
writeln;
repeat
       write(ERRPROMPT);
       if (ENVIRONMENT = MERLIN) or (ENVIRONMENT = ELITE)
       then read(ch) else readln(ch);
       writeln;
       if (ch = '\1B') or eof then begin %_rtsfin; halt(OKHALT); end;
until ch = ' ';
end; {%_pause}

end. {%flibstop}

                                                                                                         
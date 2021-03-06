(*****************************************************************************)
(*                                                                           *)
(*                             File: FLIBLW.TEXT                             *)
(*                                                                           *)
(*           (C) Copyright 1982, 1985 Silicon Valley Software, Inc.          *)
(*                                                                           *)
(*                            All Rights Reserved.               29-May-85   *)
(*                                                                           *)
(*****************************************************************************)


{$%+} {$R-} {$I-}

unit %fliblw;

interface

uses {$u flibinit} %flibinit,
     {$u flibrec}  %flibrec;

procedure %ixl(unitnum: longint);
procedure %needchars(charcount: int2);

implementation

{ Does the work for %_ixlwr and %_ixlrd }

procedure %ixl{*unitnum: longint*};
begin {%ixl}
errornumber := 0; InternalIO := FALSE;
curunit := %findunit(unitnum);
if curunit = nil
then %error(30)
else begin
  if not curunit^.Seqen then %error(94);
  if curunit^.PastEndFile and (curunit <> consoleunit) then %error(55);
  if curunit^.Formted > FORMATTED then %error(31);
  end;
end; {%ixl}


{ Initialize external write or print statement (sequential access) }

procedure %_ixlwr(unitnum: longint);
begin {%_ixlwr}
Reading := FALSE; %ixl(unitnum);
{ Set certain format controls which do not need changing during list I/O }
PrintOptionalPlus := TRUE; pval := 0; EdePresent := TRUE;
{ Set up output buffer for record }
recbufp := 1; lastwritten := 0; maxlastwritten := 0;
%putch(' '); NeedBlank := FALSE;
end; {%_ixlwr}


{ Initialize external write or print statement (sequential access), UNIT=* }

procedure %_ixlwrd;
begin {%_ixlwrd}
%_ixlwr(0);
end; {%_ixlwrd}


{ Terminate write or print statement }

procedure %_tlwr(fiostat: plongint; errexit: pcodearray);
begin {%_tlwr}
if curunit <> nil then curunit^.lastop := WRITEOP;
%nextrec; %termiostmt(fiostat,errexit);
end; {%_tlwr}


{ Terminate write or print statement, no error checking }

procedure %_tlwrd;
  var errexit: pcodearray;
begin {%_tlwrd}
if curunit <> nil then curunit^.lastop := WRITEOP;
%nextrec; errexit[1] := nil; %termiostmt(nil,errexit);
end; {%_tlwrd}


{ Sets up a field charcount wide to be written using list I/O.   }
{ Needchars provides the blank separator if necessary and leaves }
{ edw and NeedBlank in the state most often needed.              }

procedure %needchars{*charcount: int2*};
  var i: integer;
begin {%needchars}
edw := charcount; { default }
if NeedBlank then charcount := charcount + 3;
if (recbufp + charcount) > 72 
then begin %nextrec; %putch(' ') end
else
  if NeedBlank then for i := 1 to 3 do %putch(' ');
NeedBlank := TRUE; { default }
end; {%needchars}


{ Write a character, list directed }

procedure %_wrlch(fpac: ppac; paclen: longint);
  var i: integer;
begin {%_wrlch}
for i := 1 to paclen do begin
  if recbufp > 72 then begin %nextrec; %putch(' '); end;
  %putch(fpac^[i]);
  end;
NeedBlank := FALSE;
end; {%_wrlch}

procedure %_walch(fpac: pbyte; paclen: longint; count: int4);
  var i: longint;
begin {%_walch}
for i := 1 to paclen * count do begin
  if recbufp > 72 then begin %nextrec; %putch(' '); end;
  %putch(chr(fpac^));
  fpac := pointer(ord(fpac) + 1);
  end;
NeedBlank := FALSE;
end; {%_walch}


{ Write an integer, list directed }

procedure %_wrli4(fint: int4);
  var buf: packed array[1..10] of char; i, col, colcnt: integer;
      Negative: Boolean;
begin {%_wrli4}
Negative := TRUE; { Unless otherwise discovered }
if fint = -2147483648
then begin buf := '2147483648'; col := 0; end
else begin
  if fint < 0 then fint := - fint else Negative := FALSE; 
  col := 10; buf := '          ';
  repeat
    buf[col] := chr((fint mod 10) + ord('0'));
    fint := fint div 10; col := col - 1;
  until fint = 0;
  end;
if Negative then colcnt := 11 - col else colcnt := 10 - col;
%needchars(colcnt);
if Negative then %putch('-');
for i := col + 1 to 10 do
  %putch(buf[I]);
end; {%_wrli4}

procedure %_wrli2(fint: int2);
begin {%_wrli2}
%_wrli4(fint);
end; {%_wrli2}

procedure %_wrli1(fint: int1);
begin {%_wrli1}
%_wrli4(fint);
end; {%_wrli1}

procedure %_wali4(var fintarray: int4array; count: int4);
  var ctr: longint;
begin {%_wali4}
for ctr := 1 to count do
  %_wrli4(fintarray[ctr]);
end; {%_wali4}

procedure %_wali2(var fintarray: int2array; count: int4);
  var ctr: longint;
begin {%_wali2}
for ctr := 1 to count do
  %_wrli4(fintarray[ctr]);
end; {%_wali2}

procedure %_wali1(var fintarray: int1array; count: int4);
  var ctr: longint;
begin {%_wali1}
for ctr := 1 to count do
  %_wrli4(fintarray[ctr]);
end; {%_wali1}


{ Write a logical, list directed }

procedure %_wrll4(flog: int4);
begin {%_wrll4}
%needchars(1); if flog = 0 then %putch('F') else %putch('T');
end; {%_wrll4}

procedure %_wrll2(flog: int2);
begin {%_wrll2}
%needchars(1); if flog = 0 then %putch('F') else %putch('T');
end; {%_wrll2}

procedure %_wrll1(flog: int1);
begin {%_wrll1}
%needchars(1); if flog = 0 then %putch('F') else %putch('T');
end; {%_wrll1}

procedure %_wall4(var flogarray: int4array; count: int4);
  var ctr: longint;
begin {%_wall4}
for ctr := 1 to count do
  %_wrll4(flogarray[ctr]);
end; {%_wall4}

procedure %_wall2(var flogarray: int2array; count: int4);
  var ctr: longint;
begin {%_wall2}
for ctr := 1 to count do
  %_wrll2(flogarray[ctr]);
end; {%_wall2}

procedure %_wall1(var flogarray: int1array; count: int4);
  var ctr: longint;
begin {%_wall1}
for ctr := 1 to count do
  %_wrll1(flogarray[ctr]);
end; {%_wall1}

end. {%fliblw}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
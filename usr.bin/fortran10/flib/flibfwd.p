(*****************************************************************************)
(*                                                                           *)
(*                            File: FLIBFWD.TEXT                             *)
(*                                                                           *)
(*           (C) Copyright 1982, 1985 Silicon Valley Software, Inc.          *)
(*                                                                           *)
(*                            All Rights Reserved.               10-May-85   *)
(*                                                                           *)
(*****************************************************************************)


{$%+} {$R-} {$I-}

unit %flibfwd;

interface

uses {$u flibinit} %flibinit,
     {$u flibrec}  %flibrec,
     {$u flibfmt}  %flibfmt,
     {$u flibwd}   %flibwd;

implementation


{ Write a double, formatted }

procedure %_wrfr8(freal: real8);
begin {%_wrfr8}
%getfmt;
if AorZFlag then %%wrfch(@freal,8) else %putr8(freal);
end; {%_wrfr8}


{ Write a double array, formatted }

procedure %_wafr8(var frealarray: real8array; count: int4);
  var ctr: longint;
begin {%_wafr8}
for ctr := 1 to count do
  %_wrfr8(frealarray[ctr]);
end; {%_wafr8}

end. {%flibfwd}

                                                                                                                                                                                                                                                              
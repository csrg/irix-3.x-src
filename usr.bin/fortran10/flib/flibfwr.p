(*****************************************************************************)
(*                                                                           *)
(*                            File: FLIBFWR.TEXT                             *)
(*                                                                           *)
(*           (C) Copyright 1982, 1985 Silicon Valley Software, Inc.          *)
(*                                                                           *)
(*                            All Rights Reserved.               10-May-85   *)
(*                                                                           *)
(*****************************************************************************)


{$%+} {$R-} {$I-}

unit %flibfwr;

interface

uses {$u flibinit} %flibinit,
     {$u flibrec}  %flibrec,
     {$u flibfmt}  %flibfmt,
     {$u flibwr}   %flibwr;

implementation


{ Write a real, formatted }

procedure %_wrfr4(freal: real4);
begin {%_wrfr4}
%getfmt;
if AorZFlag then %%wrfch(@freal,4) else %putr4(freal);
end; {%_wrfr4}


{ Write a complex, formatted }

procedure %_wrfc8(fimag,freal: real4);
begin {%_wrfc8}
%_wrfr4(freal); %_wrfr4(fimag);
end; {%_wrfc8}


{ Write a real array, formatted }

procedure %_wafr4(var frealarray: real4array; count: int4);
  var ctr: longint;
begin {%_wafr4}
for ctr := 1 to count do
  %_wrfr4(frealarray[ctr]);
end; {%_wafr4}


{ Write a complex array, formatted }

procedure %_wafc8(var fcomplexarray: complexarray; count: int4);
  var ctr: longint;
begin {%_wafc8}
for ctr := 1 to count do
  %_wrfc8(fcomplexarray[ctr].imagpart,fcomplexarray[ctr].realpart);
end; {%_wafc8}

end. {%flibfwr}

                                                                                                                                                                                                                                                                                                                                                                                                 
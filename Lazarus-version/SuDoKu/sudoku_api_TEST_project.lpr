program sudoku_api_TEST_project;

   uses testSDKSolve, CRT;

begin

  { disable changing of characters CodePage, needed for box symbols to draw UI }
  SetUseACP(FALSE);
  //SetUseACP(true);
  //SetSafeCPSwitching(false);

  RunTests;

end.


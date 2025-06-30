unit unVariables;

interface
type
  TArrayBytes1 = array [0..2*1024*1024 - 1] of byte;
  TArrayBytes2 = array [0..59] of byte;

var
  iFileSize, iKeyLength, iBufferSize: integer;
  ArrayByteUnicode: TArrayBytes1;
  KeyUnicode: TArrayBytes1;
  
implementation

end.

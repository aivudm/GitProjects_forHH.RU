unit unConstantFiles;

interface
uses windows;
const
     MaxLengthDOSPath: byte = 255;
     DiskIOBufferSizeOS: dword = 64*1024;
     SizeCurrentNeedCombination = 1;
type
  TLegalDelemitersDOS = set of char;

type
    TNeedCombination = array [1..SizeCurrentNeedCombination] of char;
    PNeedCombination = Pointer;

const
     LegalDelemitersDOSPath: TLegalDelemitersDOS = ['\', '/'];
     DOSPathDelemiter = '\';
const
     NameINIFile: String = 'FSCorrector.ini';
     NoSelectedDirectory: string = 'NoSelectedDirectory';
     NoFiles: string = 'AllFilesInDirectory';

     FmOpenInfo = 2;
     NeedCombination_FileEnd: TNeedCombination=(char($1A));

//------- for EDO ---------------
          edoChild: byte = 0;
          edoCurrentLevelNeighbour: byte = 1;
implementation

end.
 
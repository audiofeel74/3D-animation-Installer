
//  3DAnimation
//  FMXInno.dll 28-Aug-2024
//  audiofeel, Hitman797
//  Last Updated: 20-Sep-2024

#if VER >= 0x06030000  /* InnoSetup 6.3.0 or newer */
  #define Public ReadMInI(Str sFunc, Str sParams) \
    Local[0] = sFunc + " " + sParams + " """ + AddBackSlash(SourcePath) + "3DE.ini" + """" , ExecAndGetFirstLine(AddBackSlash(SourcePath) + "Plugin\MInI\MInI.exe", Local[0], "")

#else  /* Old InnoSetup Versions */
  #define Public ReadMInI(Str sFunc, Str sParams) \
    Local[0] = AddBackSlash(GetEnv("TEMP")) + "MInI_.istmp_", DeleteFile(Local[0]), Local[1] = sFunc + " " + sParams + " " + "/o=""" + Local[0] + """" +" """ + AddBackSlash(SourcePath) + "3DE.ini" + """" , \
    Exec(AddBackSlash(SourcePath) + "Plugin\MInI\MInI.exe", Local[1], "", 1, SW_HIDE), Local[2] = FileOpen(Local[0]), Local[3] = FileRead(Local[2]), FileClose(Local[2]), DeleteFile(Local[0]), Local[3]
#endif

#define Public i 0

// Redists:
#define Public MAX_REDIST Int(ReadMInI('GetSubSectionsCount', '/MainSec=Redists /RootOnly=true'))
// Compos:
#define Public MAX_COMPO Int(ReadMInI('GetSubSectionsCount', '/MainSec=Compos /RootOnly=true'))
// AppExes:
#define Public MAX_ICONS Int(ReadMInI('GetSubSectionsCount', '/MainSec=Execs /RootOnly=true'))
// Disks:
#define Public MAX_DISKS Int(ReadMInI('GetSubSectionsCount', '/MainSec=Datas /RootOnly=true'))

[Setup]
AppId={{96C18C49-D2FF-47CD-9C56-02E53F5EE64E}
AppName={#ReadMInI('ReadString', '/Sec=Game /Key=Name')}
AppVerName={#ReadMInI('ReadString', '/Sec=Game /Key=Version')}
AppPublisher={#ReadMInI('ReadString', '/Sec=Game /Key=Publisher')}
Compression=lzma2/ultra64
DefaultDirName={autopf}\{#SetupSetting('AppName')}
DefaultGroupName={#SetupSetting('AppName')}
DirExistsWarning=False
DisableProgramGroupPage=True
DisableReadyPage=True
DisableWelcomePage=True  
InternalCompressLevel=ultra64
OutputBaseFilename=3DE
SolidCompression=True
UninstallDisplayIcon={uninstallexe}
UninstallDisplayName={#SetupSetting('AppName')}
UninstallFilesDir={app}\Uninstall
UsePreviousAppDir=False
WizardStyle=modern

[Files]
Source: "Modules\FMXInno.dll"; Flags: dontcopy
Source: "Files\*"; Flags: dontcopy recursesubdirs

Source: "Unpack\english.ini"; Flags: dontcopy
Source: "Unpack\arc.ini"; Flags: dontcopy
Source: "Unpack\cls.ini"; Flags: dontcopy
Source: "Unpack\facompress.dll"; Flags: dontcopy
Source: "Unpack\unarc.dll"; Flags: dontcopy
#include "Script_ToolsList.iss"

#if MAX_ICONS > 0
[Icons]
#sub InitAppIcons
  #define IcnSubSec ReadMInI('GetSubSection', '/MainSec=Execs /Idx=' + Str(i) + ' /RootOnly=true')
  #if IcnSubSec != ""
    #define IcnName ReadMInI('ReadSubString', '/MainSec=Execs /SubSec=' + IcnSubSec + ' /Key=Name')
    #define IcnExe ReadMInI('ReadSubString', '/MainSec=Execs /SubSec=' + IcnSubSec + ' /Key=Exe')
    #define IcnIcon ReadMInI('ReadSubString', '/MainSec=Execs /SubSec=' + IcnSubSec + ' /Key=Icon')
    #define IcnIconIdx ReadMInI('ReadSubString', '/MainSec=Execs /SubSec=' + IcnSubSec + ' /Key=IconIdx')
    #define IcnArgs ReadMInI('ReadSubString', '/MainSec=Execs /SubSec=' + IcnSubSec + ' /Key=Args')
    #define IcnWorkingDir ReadMInI('ReadSubString', '/MainSec=Execs /SubSec=' + IcnSubSec + ' /Key=WorkingDir')
Name: "{autodesktop}\{#IcnName}"; Filename: "{#IcnWorkingDir}\{#IcnExe}"; IconFilename: "{#IcnWorkingDir}\{#IcnIcon}"; IconIndex: {#IcnIconIdx}; Parameters: {#IcnArgs}; WorkingDir: "{#IcnWorkingDir}"; Check: CreateDesktopIcons;
Name: "{group}\{#IcnName}"; Filename: "{#IcnWorkingDir}\{#IcnExe}"; IconFilename: "{#IcnWorkingDir}\{#IcnIcon}"; IconIndex: {#IcnIconIdx}; Parameters: {#IcnArgs}; WorkingDir: "{#IcnWorkingDir}"; Check: CreateGroupIcons;
  #endif
#endsub
#for {i = 0; i < MAX_ICONS; i++} InitAppIcons
#endif

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
#include "Modules\FMXInnoHandle.iss"

type
  TMyData = record
    Caption, FileName, Args, SizeTxt: String;
    SizeMB: Integer;
  end;

var
  FMXForm: FForm;
  RequirementsOK: Boolean;
  ComponentSize: Integer;
  FMXColor1, FMXColor2, FMXColor3: TAlphaColor;
  FMXCpuUsage: FCpuUsage;
  FMXRamUsage: FRamUsage;
  FMXGpuInfo: FGPUInfo;
  FMXOSInfo: FOSInfo;
  FMXDiskUsage: FDiskUsage;
  FMXTabControl: array [1..3] of FTabControl;
  FMXTabItem: array [1..11] of FTabItem;
  FMXViewport3D: FViewport3D;
  FMXLayer3D: array [1..2] of FLayer3D;
  FMXFloatAnimation: array [1..8] of FFloatAnimation;
  FMXLayout: FLayout;
  FMXRectangle: array [1..100] of FRectangle;
  FMXLabel: array [1..78] of FLabel;
  FMXGlow: FGlow;
  FMXMemo: FMemo;
  FMXComboColorBox: array [1..3] of FComboColorBox;
  FMXCheckboxTree : FCheckboxTree;
  FMXCheckBox: FCheckBox;
  FMXEdit: FEdit;
  FMXCircle: array [1..5] of FCircle;
  FMXProgressBar: FThinProgressBar;
  FMXArc: array [1..2] of FArc;
#if MAX_ICONS > 0
  FMXCheckBoxIcons: array [1..2] of FCheckBox;
#endif
#if MAX_REDIST > 0
  SectionRedist : Longint;
  RedistCheckBox : array [1..{#MAX_REDIST}] of Longint;
  RedistData : array [1..{#MAX_REDIST}] of TMyData;
#endif
#if MAX_COMPO > 0
  SectionCompo : Longint;
  CompoCheckBox : array [1..{#MAX_COMPO}] of Longint;
  CompoData : array [1..{#MAX_COMPO}] of TMyData;
#endif

procedure FMXInnoInit;
var
  i: Integer;
begin
  FMXForm:= InitFormHandle;
  RequirementsOK:= False;
  FMXColor1:= {#ReadMInI('ReadString', '/Sec=Game /Key=Color1')};
  FMXColor2:= {#ReadMInI('ReadString', '/Sec=Game /Key=Color2')};
  FMXColor3:= {#ReadMInI('ReadString', '/Sec=Game /Key=Color3')};
  FMXCpuUsage:= InitCpuUsage;
  FMXRamUsage:= InitRamUsage;
  FMXGpuInfo:= InitGPUInfo;
  FMXOSInfo:= InitOSInfo;
  FMXDiskUsage:= InitDiskUsage;
  for i:= 1 to 3 do FMXTabControl[i]:= InitTabControlHandle;
  for i:= 1 to 11 do FMXTabItem[i]:= InitTabItemHandle;
  FMXViewport3D:= InitViewport3DHandle;
  for i:= 1 to 2 do FMXLayer3D[i]:= InitLayer3DHandle;
  for i:= 1 to 8 do FMXFloatAnimation[i]:= InitFloatAnimationHandle;
  FMXLayout:= InitLayoutHandle;
  for i:= 1 to 100 do FMXRectangle[i]:= InitRectangleHandle;
  for i:= 1 to 78 do FMXLabel[i]:= InitLabelHandle;
  FMXGlow:= InitGlowHandle;
  for i:= 1 to 3 do FMXComboColorBox[i]:= InitComboColorBoxHandle;
  FMXMemo:= InitMemoHandle;
  FMXCheckBox:= InitCheckBoxHandle;
  FMXCheckboxTree := InitCheckboxTreeHandle;
  FMXEdit:= InitEditHandle;
  FMXProgressBar:= InitThinProgressBarHandle;
  for i:= 1 to 5 do FMXCircle[i]:= InitCircleHandle;
  for i:= 1 to 2 do FMXArc[i]:= InitArcHandle;
#if MAX_ICONS > 0
  for i:= 1 to 2 do FMXCheckBoxIcons[i]:= InitCheckBoxHandle;
#endif
end;

function InitializeSetup: Boolean;
begin
  AddFontResource2(ExtractAndLoad('RCRfont.ttf'));

  FMXInnoInit;

  Result:= True;
end;

procedure DeinitializeSetup();
begin
  RemoveFontResource2(ExpandConstant('{tmp}\RCRfont.ttf'));

  FMXInnoShutDown;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  Confirm:= False;
end;

function ProgressCallbackEx(OverallPct, CurrentPct, DiskTotalMB, DiskExtractedMB, TotalFiles, CurFiles: Integer; DiskName, CurrentFile, RemainsTimeS, ElapsedTimeS, CurSpeed, AvgSpeed: WideString): longword;
begin
  FMXProgressBar.SetValue(OverallPct, 1000);
  FMXLabel[57].Text(RemainsTimeS);
  FMXLabel[59].Text(ElapsedTimeS);
  FMXLabel[61].Text(MbOrTb(ISArcExGetExtractedSizeMBOfAllDisks, 2));
  FMXLabel[63].Text(MbOrTb(ISArcExGetTotalSizeMBOfAllDisks, 2));
  FMXLabel[64].Text(IntToStr(OverallPct div 10) + '%');
  FMXLabel[71].Text(ElapsedTimeS);
  FMXLabel[74].Text(IntToStr(OverallPct div 10) + '%');
  FMXLabel[78].Text(RemainsTimeS);
  FMXArc[2].Angle(OverallPct, 1000);

  Result:= ISArcExCancel;
end;

#if MAX_ICONS > 0
function CreateDesktopIcons: Boolean;
begin
  Result:= (not ISArcExError) and FMXCheckBoxIcons[1].ISChecked;
end;

function CreateGroupIcons: Boolean;
begin
  Result:= (not ISArcExError) and FMXCheckBoxIcons[2].ISChecked;
end;
#endif

procedure CalculateSize(Sender : TObject);
var
  AdditionalSize, i: Integer;
begin
  AdditionalSize:= {#ReadMInI('ReadString', '/Sec=Game /Key=SizeMB')};

#if MAX_COMPO > 0
  for i:= 1 to GetArrayLength(CompoData) do
    if FMXCheckboxTree.CheckboxGetChecked(CompoCheckBox[i]) then
      AdditionalSize:= AdditionalSize + CompoData[i].SizeMB;
#endif

  ComponentSize:= AdditionalSize;

  FMXDiskUsage.SetDir(WizardForm.DirEdit.Text);

  FMXLabel[42].Text(MbOrTb(ComponentSize, 1));
  FMXLabel[44].Text(MbOrTb(FMXDiskUsage.FreeSpace, 1));
  FMXLabel[50].Text(MbOrTb(ComponentSize, 1));
  FMXLabel[52].Text(MbOrTb(FMXDiskUsage.FreeSpace, 1));

  if Round(FMXDiskUsage.FreeSpace) > Round(ComponentSize) then
  begin
    FMXLabel[45].Text('Enough Space');
    FMXLabel[46].Text(#$E10B);
    FMXLabel[53].Text('Enough Space');
    FMXLabel[54].Text(#$E10B);
  end else
  begin
    FMXLabel[45].Text('Not enough space');
    FMXLabel[46].Text(#$E10A);
    FMXLabel[53].Text('Not enough space');
    FMXLabel[54].Text(#$E10A);
  end;
end;

procedure CommonOnClick(Sender: TObject);
var
  ADir: WideString;
begin
  case Sender of

    // Close Button:
    TObject(FMXRectangle[2].GetObject):
    begin
      if WizardForm.CurPageID = wpInstalling then
      begin
        ISArcExCancel:= 1;
        ISArcExResumeProc;
      end else
      if WizardForm.CurPageID = wpFinished then
        WizardForm.NextButton.OnClick(Sender)
      else
        WizardForm.CancelButton.OnClick(Sender);
    end;

    // Minimize Button:
    TObject(FMXRectangle[3].GetObject):
    begin
      if WizardForm.CurPageID = wpInstalling then
        FMXTabControl[1].Next(ttSlide, ttdNormal)
      else
        pMinimizeWindow(WizardForm.Handle);
    end;

    // Tile Information:
    TObject(FMXRectangle[8].GetObject):
    begin
      FMXTabItem[5].IsSelected(True);
      FMXLabel[17].Text('Information');
      FMXLabel[18].Text(#$E16D);

      FMXLayer3D[1].RotationAngle(0, 0, 0);
      FMXLayer3D[2].RotationAngle(180, 0, 0);

      FMXFloatAnimation[1].StopAtCurrent;
      FMXFloatAnimation[1].SetValues(0, 180);
      FMXFloatAnimation[1].Start;
      FMXFloatAnimation[3].StopAtCurrent;
      FMXFloatAnimation[3].SetValues(180, 360);
      FMXFloatAnimation[3].Start;

      FMXLayer3D[1].BringToFront;
    end;

    // Tile App overview:
    TObject(FMXRectangle[9].GetObject):
    begin
      FMXTabItem[6].IsSelected(True);
      FMXLabel[17].Text('App overview');
      FMXLabel[18].Text(#$E243);

      FMXLayer3D[1].RotationAngle(0, 0, 0);
      FMXLayer3D[2].RotationAngle(180, 0, 0);

      FMXFloatAnimation[1].StopAtCurrent;
      FMXFloatAnimation[1].SetValues(0, 180);
      FMXFloatAnimation[1].Start;
      FMXFloatAnimation[3].StopAtCurrent;
      FMXFloatAnimation[3].SetValues(180, 360);
      FMXFloatAnimation[3].Start;

      FMXLayer3D[1].BringToFront;
    end;

    // Tile System requirements:
    TObject(FMXRectangle[10].GetObject):
    begin
      FMXTabItem[7].IsSelected(True);
      FMXLabel[17].Text('System requirements');
      FMXLabel[18].Text(#$E211);

      FMXLayer3D[1].RotationAngle(0, 0, 0);
      FMXLayer3D[2].RotationAngle(180, 0, 0);

      FMXFloatAnimation[1].StopAtCurrent;
      FMXFloatAnimation[1].SetValues(0, 180);
      FMXFloatAnimation[1].Start;
      FMXFloatAnimation[3].StopAtCurrent;
      FMXFloatAnimation[3].SetValues(180, 360);
      FMXFloatAnimation[3].Start;

      FMXLayer3D[1].BringToFront;
    end;

    // Tile Select components:
    TObject(FMXRectangle[11].GetObject):
    begin
      FMXTabItem[8].IsSelected(True);
      FMXLabel[17].Text('Select components');
      FMXLabel[18].Text(#$E1EF);

      FMXLayer3D[1].RotationAngle(0, 0, 0);
      FMXLayer3D[2].RotationAngle(180, 0, 0);

      FMXFloatAnimation[1].StopAtCurrent;
      FMXFloatAnimation[1].SetValues(0, 180);
      FMXFloatAnimation[1].Start;
      FMXFloatAnimation[3].StopAtCurrent;
      FMXFloatAnimation[3].SetValues(180, 360);
      FMXFloatAnimation[3].Start;

      FMXLayer3D[1].BringToFront;
    end;

    // Tile Configure installation:
    TObject(FMXRectangle[12].GetObject):
    begin
      FMXTabItem[9].IsSelected(True);
      FMXLabel[17].Text('Configure installation');
      FMXLabel[18].Text(#$E28F);

      FMXLayer3D[1].RotationAngle(0, 0, 0);
      FMXLayer3D[2].RotationAngle(180, 0, 0);

      FMXFloatAnimation[1].StopAtCurrent;
      FMXFloatAnimation[1].SetValues(0, 180);
      FMXFloatAnimation[1].Start;
      FMXFloatAnimation[3].StopAtCurrent;
      FMXFloatAnimation[3].SetValues(180, 360);
      FMXFloatAnimation[3].Start;

      FMXLayer3D[1].BringToFront;
    end;

    // Tile Start installation:
    TObject(FMXRectangle[13].GetObject):
    begin
      FMXTabItem[10].IsSelected(True);
      FMXLabel[17].Text('Start installation');
      FMXLabel[18].Text(#$E184);

      FMXLayer3D[1].RotationAngle(0, 0, 0);
      FMXLayer3D[2].RotationAngle(180, 0, 0);

      FMXFloatAnimation[1].StopAtCurrent;
      FMXFloatAnimation[1].SetValues(0, 180);
      FMXFloatAnimation[1].Start;
      FMXFloatAnimation[3].StopAtCurrent;
      FMXFloatAnimation[3].SetValues(180, 360);
      FMXFloatAnimation[3].Start;

      FMXLayer3D[1].BringToFront;

      WizardForm.NextButton.OnClick(Sender);
    end;

    // Page Back Buttons:
    TObject(FMXRectangle[20].GetObject),
    TObject(FMXRectangle[35].GetObject),
    TObject(FMXRectangle[50].GetObject),
    TObject(FMXRectangle[62].GetObject),
    TObject(FMXRectangle[75].GetObject):
    begin
      FMXLayer3D[1].RotationAngle(0, 180, 0);
      FMXLayer3D[2].RotationAngle(0, 0, 0);

      FMXFloatAnimation[2].StopAtCurrent;
      FMXFloatAnimation[2].SetValues(180, 360);
      FMXFloatAnimation[2].Start;
      FMXFloatAnimation[4].StopAtCurrent;
      FMXFloatAnimation[4].SetValues(0, 180);
      FMXFloatAnimation[4].Start;

      FMXLayer3D[2].BringToFront;
    end;

    // Browse Button:
    TObject(FMXEdit.GetSearchBtnObject):
    begin
  		if BrowseDirModern(FMXForm.HandleHWND, 'Select Folder', ADir) then
      begin
        WizardForm.DirEdit.Text:= AddBackslash(ADir) + ExpandConstant('{#SetupSetting('AppName')}');
        FMXEdit.Text(MinimizePathName(WizardForm.DirEdit.Text, WizardForm.DirEdit.Font, WizardForm.DirEdit.Width -50));
      end;
      CalculateSize(nil);
    end;

    // Exit Button:
    TObject(FMXRectangle[96].GetObject):
      WizardForm.NextButton.OnClick(Sender);

    // Mini Form Back Button:
    TObject(FMXCircle[5].GetObject):
    begin
      if WizardForm.CurPageID = wpFinished then
        WizardForm.NextButton.OnClick(Sender)
      else
        FMXTabControl[1].Previous(ttSlide, ttdReversed);
    end;

  end;
end;

procedure CommonOnEnter(Sender: TObject);
begin
  case Sender of

    // Close Button:
    TObject(FMXRectangle[2].GetObject):
      FMXRectangle[2].AnimateColor(FllColor, FMXColor3, 0.2);

    // Minimize Button:
    TObject(FMXRectangle[3].GetObject):
      FMXRectangle[3].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Information:
    TObject(FMXRectangle[8].GetObject):
      FMXRectangle[8].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile App overview:
    TObject(FMXRectangle[9].GetObject):
      FMXRectangle[9].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile System requirements:
    TObject(FMXRectangle[10].GetObject):
      FMXRectangle[10].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Select components:
    TObject(FMXRectangle[11].GetObject):
      FMXRectangle[11].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Configure installation:
    TObject(FMXRectangle[12].GetObject):
      FMXRectangle[12].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Start installation:
    TObject(FMXRectangle[13].GetObject):
      FMXRectangle[13].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page Information Back Button:
    TObject(FMXRectangle[20].GetObject):
      FMXRectangle[20].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page App overview Back Button:
    TObject(FMXRectangle[35].GetObject):
      FMXRectangle[35].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page System requirements Back Button:
    TObject(FMXRectangle[50].GetObject):
      FMXRectangle[50].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page System requirements Back Button:
    TObject(FMXRectangle[62].GetObject):
      FMXRectangle[62].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page Configure installation Back Button:
    TObject(FMXRectangle[75].GetObject):
      FMXRectangle[75].AnimateColor(FllColor, FMXColor3, 0.2);

    // Exit Button:
    TObject(FMXRectangle[96].GetObject):
      FMXRectangle[96].AnimateColor(FllColor, FMXColor3, 0.2);

    // Mini Form Back Button:
    TObject(FMXCircle[5].GetObject):
      FMXCircle[5].AnimateColor(FllColor, FMXColor3, 0.2);

  end;
end;

procedure CommonOnLeave(Sender: TObject);
begin
  case Sender of

    // Close Button:
    TObject(FMXRectangle[2].GetObject):
      FMXRectangle[2].AnimateColor(FllColor, FMXColor2, 0.2);

    // Minimize Button:
    TObject(FMXRectangle[3].GetObject):
      FMXRectangle[3].AnimateColor(FllColor, FMXColor2, 0.2);

    // Title Bar:
    TObject(FMXRectangle[4].GetObject):
      FMXRectangle[4].AnimateColor(FllColor, FMXColor2, 0.2);

    // Tile Information:
    TObject(FMXRectangle[8].GetObject):
      FMXRectangle[8].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile App overview:
    TObject(FMXRectangle[9].GetObject):
      FMXRectangle[9].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile System requirements:
    TObject(FMXRectangle[10].GetObject):
      FMXRectangle[10].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile Select components:
    TObject(FMXRectangle[11].GetObject):
      FMXRectangle[11].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile Configure installation:
    TObject(FMXRectangle[12].GetObject):
      FMXRectangle[12].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile Start installation:
    TObject(FMXRectangle[13].GetObject):
      FMXRectangle[13].AnimateColor(FllColor, FMXColor1, 0.2);

    // Page Information Back Button:
    TObject(FMXRectangle[20].GetObject):
      FMXRectangle[20].AnimateColor(FllColor, FMXColor2, 0.2);

    // Page App overview Back Button:
    TObject(FMXRectangle[35].GetObject):
      FMXRectangle[35].AnimateColor(FllColor, FMXColor2, 0.2);

    // Page System requirements Back Button:
    TObject(FMXRectangle[50].GetObject):
      FMXRectangle[50].AnimateColor(FllColor, FMXColor2, 0.2);

    // Page System requirements Back Button:
    TObject(FMXRectangle[62].GetObject):
      FMXRectangle[62].AnimateColor(FllColor, FMXColor2, 0.2);

    // Page Configure installation Back Button:
    TObject(FMXRectangle[75].GetObject):
      FMXRectangle[75].AnimateColor(FllColor, FMXColor2, 0.2);

    // Exit Button:
    TObject(FMXRectangle[96].GetObject):
      FMXRectangle[96].AnimateColor(FllColor, FMXColor2, 0.2);

    // Mini Form Title Bar:
    TObject(FMXRectangle[98].GetObject):
      FMXRectangle[98].AnimateColor(FllColor, FMXColor2, 0.2);

    // Mini Form Back Button:
    TObject(FMXCircle[5].GetObject):
      FMXCircle[5].AnimateColor(FllColor, FMXColor1, 0.2);

  end;
end;

procedure CommonOnDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  case Sender of

    // Close Button:
    TObject(FMXRectangle[2].GetObject):
      FMXRectangle[2].AnimateColor(FllColor, FMXColor2, 0.2);

    // Minimize Button:
    TObject(FMXRectangle[3].GetObject):
      FMXRectangle[3].AnimateColor(FllColor, FMXColor2, 0.2);

    // Title Bar:
    TObject(FMXRectangle[4].GetObject):
      FMXRectangle[4].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Information:
    TObject(FMXRectangle[8].GetObject):
      FMXRectangle[8].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile App overview:
    TObject(FMXRectangle[9].GetObject):
      FMXRectangle[9].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile System requirements:
    TObject(FMXRectangle[10].GetObject):
      FMXRectangle[10].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile Select components:
    TObject(FMXRectangle[11].GetObject):
      FMXRectangle[11].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile Configure installation:
    TObject(FMXRectangle[12].GetObject):
      FMXRectangle[12].AnimateColor(FllColor, FMXColor1, 0.2);

    // Tile Start installation:
    TObject(FMXRectangle[13].GetObject):
      FMXRectangle[13].AnimateColor(FllColor, FMXColor1, 0.2);

    // Page Information Back Button:
    TObject(FMXRectangle[20].GetObject):
      FMXRectangle[20].AnimateColor(FllColor, FMXColor2, 0.2);

    // Page App overview Back Button:
    TObject(FMXRectangle[35].GetObject):
      FMXRectangle[35].AnimateColor(FllColor, FMXColor2, 0.2);

    // Page System requirements Back Button:
    TObject(FMXRectangle[50].GetObject):
      FMXRectangle[50].AnimateColor(FllColor, FMXColor2, 0.2);

    // Page System requirements Back Button:
    TObject(FMXRectangle[62].GetObject):
      FMXRectangle[62].AnimateColor(FllColor, FMXColor2, 0.2);

    // Page Configure installation Back Button:
    TObject(FMXRectangle[75].GetObject):
      FMXRectangle[75].AnimateColor(FllColor, FMXColor2, 0.2);

    // Exit Button:
    TObject(FMXRectangle[96].GetObject):
      FMXRectangle[96].AnimateColor(FllColor, FMXColor2, 0.2);

    // Mini Form Title Bar:
    TObject(FMXRectangle[98].GetObject):
      FMXRectangle[98].AnimateColor(FllColor, FMXColor3, 0.2);

    // Mini Form Back Button:
    TObject(FMXCircle[5].GetObject):
      FMXCircle[5].AnimateColor(FllColor, FMXColor1, 0.2);

  end;
end;

procedure CommonOnUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  case Sender of

    // Close Button:
    TObject(FMXRectangle[2].GetObject):
      FMXRectangle[2].AnimateColor(FllColor, FMXColor3, 0.2);

    // Minimize Button:
    TObject(FMXRectangle[3].GetObject):
      FMXRectangle[3].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Information:
    TObject(FMXRectangle[8].GetObject):
      FMXRectangle[8].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile App overview:
    TObject(FMXRectangle[9].GetObject):
      FMXRectangle[9].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile System requirements:
    TObject(FMXRectangle[10].GetObject):
      FMXRectangle[10].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Select components:
    TObject(FMXRectangle[11].GetObject):
      FMXRectangle[11].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Configure installation:
    TObject(FMXRectangle[12].GetObject):
      FMXRectangle[12].AnimateColor(FllColor, FMXColor3, 0.2);

    // Tile Start installation:
    TObject(FMXRectangle[13].GetObject):
      FMXRectangle[13].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page Information Back Button:
    TObject(FMXRectangle[20].GetObject):
      FMXRectangle[20].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page App overview Back Button:
    TObject(FMXRectangle[35].GetObject):
      FMXRectangle[35].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page System requirements Back Button:
    TObject(FMXRectangle[50].GetObject):
      FMXRectangle[50].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page System requirements Back Button:
    TObject(FMXRectangle[62].GetObject):
      FMXRectangle[62].AnimateColor(FllColor, FMXColor3, 0.2);

    // Page Configure installation Back Button:
    TObject(FMXRectangle[75].GetObject):
      FMXRectangle[75].AnimateColor(FllColor, FMXColor3, 0.2);

    // Exit Button:
    TObject(FMXRectangle[96].GetObject):
      FMXRectangle[96].AnimateColor(FllColor, FMXColor3, 0.2);

    // Mini Form Back Button:
    TObject(FMXCircle[5].GetObject):
      FMXCircle[5].AnimateColor(FllColor, FMXColor3, 0.2);

  end;
end;

procedure CommonOnMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  ReleaseCapture;
  SendMessage(FMXForm.HandleHWND, $0112, $F012, 0);

  FMXRectangle[4].AnimateColor(FllColor, FMXColor2, 0.2);
  FMXRectangle[98].AnimateColor(FllColor, FMXColor2, 0.2);
end;

procedure FormOnKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  if ssCtrl in Shift then
    if Key = 68 then
      FMXRectangle[5].Visible(not FMXRectangle[5].IsVisible);
end;

procedure ColorOnChange(Sender: TObject);
begin
  FMXColor1:= FMXComboColorBox[1].GetColor;
  FMXColor2:= FMXComboColorBox[2].GetColor;
  FMXColor3:= FMXComboColorBox[3].GetColor;

  FMXRectangle[1].FillColor(FMXColor1);
  FMXRectangle[8].FillColor(FMXColor1);
  FMXRectangle[9].FillColor(FMXColor1);
  FMXRectangle[10].FillColor(FMXColor1);
  FMXRectangle[11].FillColor(FMXColor1);
  FMXRectangle[12].FillColor(FMXColor1);
  FMXRectangle[13].FillColor(FMXColor1);
  FMXRectangle[14].FillColor(FMXColor1);
  FMXRectangle[15].FillColor(FMXColor1);
  FMXRectangle[16].FillColor(FMXColor1);
  FMXRectangle[17].FillColor(FMXColor1);
  FMXRectangle[18].FillColor(FMXColor1);
  FMXRectangle[20].FillColor(FMXColor1);
  FMXRectangle[21].FillColor(FMXColor1);
  FMXRectangle[22].FillColor(FMXColor1);
  FMXRectangle[23].FillColor(FMXColor1);
  FMXRectangle[24].FillColor(FMXColor1);
  FMXRectangle[35].FillColor(FMXColor1);
  FMXRectangle[36].FillColor(FMXColor1);
  FMXRectangle[37].FillColor(FMXColor1);
  FMXRectangle[38].FillColor(FMXColor1);
  FMXRectangle[39].FillColor(FMXColor1);
  FMXRectangle[50].FillColor(FMXColor1);
  FMXRectangle[51].FillColor(FMXColor1);
  FMXRectangle[52].FillColor(FMXColor1);
  FMXRectangle[53].FillColor(FMXColor1);
  FMXRectangle[54].FillColor(FMXColor1);
  FMXRectangle[62].FillColor(FMXColor1);
  FMXRectangle[63].FillColor(FMXColor1);
  FMXRectangle[64].FillColor(FMXColor1);
  FMXRectangle[65].FillColor(FMXColor1);
  FMXRectangle[66].FillColor(FMXColor1);
  FMXRectangle[75].FillColor(FMXColor1);
  FMXRectangle[76].FillColor(FMXColor1);
  FMXArc[1].FillColor(FMXColor1);
  FMXRectangle[85].FillColor(FMXColor1);
  FMXRectangle[86].FillColor(FMXColor1);
  FMXRectangle[87].FillColor(FMXColor1);
  FMXRectangle[88].FillColor(FMXColor1);
  FMXRectangle[89].FillColor(FMXColor1);
  FMXRectangle[96].FillColor(FMXColor1);
  FMXRectangle[97].FillColor(FMXColor1);

  FMXRectangle[2].FillColor(FMXColor2);
  FMXRectangle[3].FillColor(FMXColor2);
  FMXRectangle[4].FillColor(FMXColor2);
  FMXRectangle[19].FillColor(FMXColor2);
  FMXRectangle[25].FillColor(FMXColor2);
  FMXRectangle[27].FillColor(FMXColor2);
  FMXRectangle[29].FillColor(FMXColor2);
  FMXRectangle[31].FillColor(FMXColor2);
  FMXRectangle[33].FillColor(FMXColor2);
  FMXRectangle[40].FillColor(FMXColor2);
  FMXRectangle[42].FillColor(FMXColor2);
  FMXRectangle[44].FillColor(FMXColor2);
  FMXRectangle[46].FillColor(FMXColor2);
  FMXRectangle[48].FillColor(FMXColor2);
  FMXRectangle[55].FillColor(FMXColor2);
  FMXRectangle[56].FillColor(FMXColor2);
  FMXRectangle[58].FillColor(FMXColor2);
  FMXRectangle[60].FillColor(FMXColor2);
  FMXRectangle[67].FillColor(FMXColor2);
  FMXRectangle[69].FillColor(FMXColor2);
  FMXRectangle[71].FillColor(FMXColor2);
  FMXRectangle[73].FillColor(FMXColor2);
  FMXRectangle[77].FillColor(FMXColor2);
  FMXRectangle[79].FillColor(FMXColor2);
  FMXRectangle[81].FillColor(FMXColor2);
  FMXRectangle[83].FillColor(FMXColor2);
  FMXCircle[1].FillColor(FMXColor2);
  FMXRectangle[90].FillColor(FMXColor2);
  FMXRectangle[92].FillColor(FMXColor2);
  FMXRectangle[94].FillColor(FMXColor2);
  FMXCircle[3].FillColor(FMXColor2);
  FMXCircle[4].FillColor(FMXColor2);
  FMXRectangle[98].FillColor(FMXColor2);
  FMXRectangle[99].FillColor(FMXColor2);

  FMXRectangle[28].FillColor(FMXColor3);
  FMXRectangle[30].FillColor(FMXColor3);
  FMXRectangle[32].FillColor(FMXColor3);
  FMXRectangle[34].FillColor(FMXColor3);
  FMXRectangle[41].FillColor(FMXColor3);
  FMXRectangle[43].FillColor(FMXColor3);
  FMXRectangle[45].FillColor(FMXColor3);
  FMXRectangle[47].FillColor(FMXColor3);
  FMXRectangle[49].FillColor(FMXColor3);
  FMXRectangle[57].FillColor(FMXColor3);
  FMXRectangle[59].FillColor(FMXColor3);
  FMXRectangle[61].FillColor(FMXColor3);
  FMXRectangle[68].FillColor(FMXColor3);
  FMXRectangle[70].FillColor(FMXColor3);
  FMXRectangle[72].FillColor(FMXColor3);
  FMXRectangle[74].FillColor(FMXColor3);
  FMXRectangle[78].FillColor(FMXColor3);
  FMXRectangle[80].FillColor(FMXColor3);
  FMXRectangle[82].FillColor(FMXColor3);
  FMXRectangle[84].FillColor(FMXColor3);
  FMXCircle[2].StrokeColor(FMXColor3);
  FMXRectangle[93].FillColor(FMXColor3);
  FMXRectangle[95].FillColor(FMXColor3);
  FMXArc[2].StrokeColor(FMXColor3);
  FMXCircle[5].StrokeColor(FMXColor3);
  FMXRectangle[100].FillColor(FMXColor3);
end;

procedure FMXDesigning;
var
  j: Integer;
begin
  FMXForm.FCreateImageForm(WizardForm.Handle, ExtractAndLoad('Form.png'), 0);
  FMXForm.LoadStyleFromFile(ExtractAndLoad('style.fsf'));
  FMXForm.OnKeyDown(@FormOnKeyDown);

  FMXTabControl[1].FCreate(FMXForm.Handle);
  FMXTabControl[1].Align(Client);
  FMXTabControl[1].StyleLookup('transparentedit');
  FMXTabControl[1].TabPosition(tpNone);

  FMXTabItem[1].FCreateEx(FMXTabControl[1].Handle);
  FMXTabItem[1].IsSelected(True);

  FMXRectangle[1].FCreate(FMXTabItem[1].Handle);
  FMXRectangle[1].Align(Client);
  FMXRectangle[1].FillColor(FMXColor1);
  FMXRectangle[1].CornerStyle(20, 20, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLayout.FCreate(FMXRectangle[1].Handle);
  FMXLayout.Align(MostTop);
  FMXLayout.Margins(16, 0, 16, 0);
  FMXLayout.Height(40);
  FMXLayout.Width(888);

  // Close Button:
  FMXRectangle[2].FCreate(FMXLayout.Handle);
  FMXRectangle[2].Align(Right);
  FMXRectangle[2].Height(40);
  FMXRectangle[2].Width(64);
  FMXRectangle[2].FillColor(FMXColor2);
  FMXRectangle[2].CornerStyle(10, 10, [tcBottomRight], ctRound);
  FMXRectangle[2].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[2].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[2].OnMouseDown(@CommonOnDown);
  FMXRectangle[2].OnMouseUp(@CommonOnUp);
  FMXRectangle[2].OnClick(@CommonOnClick);
  FMXLabel[1].FCreate(FMXRectangle[2].Handle, #$E10A);
  FMXLabel[1].Align(Client);
  FMXLabel[1].FontSetting('Segoe UI Symbol', 20, ALWhite);
  FMXLabel[1].TextSetting(False, txCenter, txCenter);

  // Minimize Button:
  FMXRectangle[3].FCreate(FMXLayout.Handle);
  FMXRectangle[3].Align(Right);
  FMXRectangle[3].Height(40);
  FMXRectangle[3].Width(40);
  FMXRectangle[3].FillColor(FMXColor2);
  FMXRectangle[3].CornerStyle(10, 10, [tcBottomLeft], ctRound);
  FMXRectangle[3].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[3].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[3].OnMouseDown(@CommonOnDown);
  FMXRectangle[3].OnMouseUp(@CommonOnUp);
  FMXRectangle[3].OnClick(@CommonOnClick);
  FMXLabel[2].FCreate(FMXRectangle[3].Handle, #$E108);
  FMXLabel[2].Align(Client);
  FMXLabel[2].FontSetting('Segoe UI Symbol', 20, ALWhite);
  FMXLabel[2].TextSetting(False, txCenter, txCenter);

  // Title Bar:
  FMXRectangle[4].FCreate(FMXLayout.Handle);
  FMXRectangle[4].Align(Client);
  FMXRectangle[4].Margins(0, 0, 16, 0);
  FMXRectangle[4].Height(40);
  FMXRectangle[4].Width(574);
  FMXRectangle[4].FillColor(FMXColor2);
  FMXRectangle[4].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[4].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[4].OnMouseDown(@CommonOnDown);
  FMXRectangle[4].OnMouseUp(@CommonOnUp);
  FMXRectangle[4].OnMouseMove(@CommonOnMove);
  FMXLabel[3].FCreate(FMXRectangle[4].Handle, 'Setup - {#SetupSetting('AppName')}');
  FMXLabel[3].Align(Client);
  FMXLabel[3].Margins(16, 0, 0, 0);
  FMXLabel[3].FontSetting('Roboto Condensed', 17, ALWhite);
  FMXLabel[3].TextSetting(True, txLeading, txCenter);

  // ComboColorBox:
  FMXRectangle[5].FCreate(FMXLayout.Handle);
  FMXRectangle[5].Margins(0, 0, 16, 0);
  FMXRectangle[5].Height(40);
  FMXRectangle[5].Width(176);
  FMXRectangle[5].Align(Right);
  FMXRectangle[5].FillColor(FMXColor2);
  FMXRectangle[5].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[5].Visible(False);

  FMXComboColorBox[1].FCreate(FMXRectangle[5].Handle);
  FMXComboColorBox[1].Align(Left);
  FMXComboColorBox[1].Margins(8, 8, 0, 8);
  FMXComboColorBox[1].Width(48);
  FMXComboColorBox[1].Color(FMXColor1);
  FMXComboColorBox[1].OnChange(@ColorOnChange);

  FMXComboColorBox[2].FCreate(FMXRectangle[5].Handle);
  FMXComboColorBox[2].Align(Left);
  FMXComboColorBox[2].Margins(8, 8, 0, 8);
  FMXComboColorBox[2].Width(48);
  FMXComboColorBox[2].Color(FMXColor2);
  FMXComboColorBox[2].OnChange(@ColorOnChange);

  FMXComboColorBox[3].FCreate(FMXRectangle[5].Handle);
  FMXComboColorBox[3].Align(Left);
  FMXComboColorBox[3].Margins(8, 8, 0, 8);
  FMXComboColorBox[3].Width(48);
  FMXComboColorBox[3].Color(FMXColor3);
  FMXComboColorBox[3].OnChange(@ColorOnChange);

  // Background:
  FMXRectangle[6].FCreate(FMXRectangle[1].Handle);
  FMXRectangle[6].SetBounds(16, 56, 886, 512);
  FMXRectangle[6].FillColor(FMXColor2);
  FMXRectangle[6].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[7].FCreate(FMXRectangle[6].Handle);
  FMXRectangle[7].SetBounds(16, 16, 854, 480);
  FMXRectangle[7].FillPicture(ExtractAndLoad('img.jpg'), wmTileStretch);
  FMXRectangle[7].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  // WaterMark:
  FMXLabel[4].FCreate(FMXRectangle[7].Handle, 'Designed by Razor12911');
  FMXLabel[4].SetBounds(8, 456, 838, 20);
  FMXLabel[4].FontSetting('Roboto Condensed', 14, ALWhite);
  FMXLabel[4].TextSetting(False, txTrailing, txLeading);
  FMXGlow.FCreate(FMXLabel[4].Handle);
  FMXGlow.Softness(0.5);
  FMXGlow.GlowColor(ALBlack);
  FMXGlow.Opacity(1);

  FMXViewport3D.FCreate(FMXRectangle[6].Handle);
  FMXViewport3D.Align(Contents);
  FMXViewport3D.Color(ALNull);
  FMXViewport3D.Height(512);
  FMXViewport3D.Width(886);
  FMXViewport3D.UsingDesignCamera(True);
  FMXViewport3D.Multisample(msFourSamples);
  FMXViewport3D.HitTest(True);

  FMXLayer3D[1].FCreate(FMXViewport3D.Handle);
  FMXLayer3D[1].Projection(pjScreen);
  FMXLayer3D[1].Position(443, 256, 0);
  FMXLayer3D[1].Resolution(50);
  FMXLayer3D[1].StyleLookup('backgroundstyle');
  FMXLayer3D[1].Transparency(True);
  FMXLayer3D[1].TwoSide(False);
  FMXLayer3D[1].Align(Client);

  FMXFloatAnimation[1].FCreate(FMXLayer3D[1].Handle);
  FMXFloatAnimation[1].Enabled(False);
  FMXFloatAnimation[1].Interpolation(itLinear);
  FMXFloatAnimation[1].AnimationType(atIn, 1, 0, False, False, False);
  FMXFloatAnimation[1].PropertyName('RotationAngle.X');
  FMXFloatAnimation[1].StartFromCurrent(False);
  FMXFloatAnimation[1].SetValues(0, 0);

  FMXFloatAnimation[2].FCreate(FMXLayer3D[1].Handle);
  FMXFloatAnimation[2].Enabled(False);
  FMXFloatAnimation[2].Interpolation(itLinear);
  FMXFloatAnimation[2].AnimationType(atIn, 1, 0, False, False, False);
  FMXFloatAnimation[2].PropertyName('RotationAngle.Y');
  FMXFloatAnimation[2].StartFromCurrent(False);
  FMXFloatAnimation[2].SetValues(0, 0);

  FMXTabControl[2].FCreate(FMXLayer3D[1].Handle);
  FMXTabControl[2].Align(Client);
  FMXTabControl[2].Margins(16, 16, 16, 16);
  FMXTabControl[2].Height(480);
  FMXTabControl[2].Width(854);
  FMXTabControl[2].StyleLookup('transparentedit');
  FMXTabControl[2].TabPosition(tpNone);

  // Tiles Page:
  FMXTabItem[3].FCreateEx(FMXTabControl[2].Handle);
  FMXTabItem[3].IsSelected(False);

  //Tile Information:
  FMXRectangle[8].FCreate(FMXTabItem[3].Handle);
  FMXRectangle[8].SetBounds(94, 76, 216, 160);
  FMXRectangle[8].FillColor(FMXColor1);
  FMXRectangle[8].CornerStyle(10, 10, [tcTopLeft], ctRound);
  FMXRectangle[8].Enabled(False);
  FMXRectangle[8].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[8].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[8].OnMouseDown(@CommonOnDown);
  FMXRectangle[8].OnMouseUp(@CommonOnUp);
  FMXRectangle[8].OnClick(@CommonOnClick);
  FMXLabel[5].FCreate(FMXRectangle[8].Handle, 'Information');
  FMXLabel[5].Align(Bottom);
  FMXLabel[5].Height(32);
  FMXLabel[5].FontSetting('Roboto Condensed', 14, ALWhite);
  FMXLabel[5].TextSetting(False, txCenter, txCenter);
  FMXLabel[6].FCreate(FMXRectangle[8].Handle, #$E16D);
  FMXLabel[6].Align(Contents);
  FMXLabel[6].FontSetting('Segoe UI Symbol', 50, ALWhite);
  FMXLabel[6].TextSetting(False, txCenter, txCenter);

  //Tile App overview:
  FMXRectangle[9].FCreate(FMXTabItem[3].Handle);
  FMXRectangle[9].SetBounds(318, 76, 216, 160);
  FMXRectangle[9].FillColor(FMXColor1);
  FMXRectangle[9].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[9].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[9].OnMouseDown(@CommonOnDown);
  FMXRectangle[9].OnMouseUp(@CommonOnUp);
  FMXRectangle[9].OnClick(@CommonOnClick);
  FMXLabel[7].FCreate(FMXRectangle[9].Handle, 'App overview');
  FMXLabel[7].Align(Bottom);
  FMXLabel[7].Height(32);
  FMXLabel[7].FontSetting('Roboto Condensed', 14, ALWhite);
  FMXLabel[7].TextSetting(False, txCenter, txCenter);
  FMXLabel[8].FCreate(FMXRectangle[9].Handle, #$E243);
  FMXLabel[8].Align(Contents);
  FMXLabel[8].FontSetting('Segoe UI Symbol', 50, ALWhite);
  FMXLabel[8].TextSetting(False, txCenter, txCenter);

  //Tile System requirements:
  FMXRectangle[10].FCreate(FMXTabItem[3].Handle);
  FMXRectangle[10].SetBounds(542, 76, 216, 160);
  FMXRectangle[10].FillColor(FMXColor1);
  FMXRectangle[10].CornerStyle(10, 10, [tcTopRight], ctRound);
  FMXRectangle[10].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[10].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[10].OnMouseDown(@CommonOnDown);
  FMXRectangle[10].OnMouseUp(@CommonOnUp);
  FMXRectangle[10].OnClick(@CommonOnClick);
  FMXLabel[9].FCreate(FMXRectangle[10].Handle, 'System requirements');
  FMXLabel[9].Align(Bottom);
  FMXLabel[9].Height(32);
  FMXLabel[9].FontSetting('Roboto Condensed', 14, ALWhite);
  FMXLabel[9].TextSetting(False, txCenter, txCenter);
  FMXLabel[10].FCreate(FMXRectangle[10].Handle, #$E211);
  FMXLabel[10].Align(Contents);
  FMXLabel[10].FontSetting('Segoe UI Symbol', 50, ALWhite);
  FMXLabel[10].TextSetting(False, txCenter, txCenter);

  //Tile Select components:
  FMXRectangle[11].FCreate(FMXTabItem[3].Handle);
  FMXRectangle[11].SetBounds(94, 244, 216, 160);
  FMXRectangle[11].FillColor(FMXColor1);
  FMXRectangle[11].CornerStyle(10, 10, [tcBottomLeft], ctRound);
  FMXRectangle[11].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[11].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[11].OnMouseDown(@CommonOnDown);
  FMXRectangle[11].OnMouseUp(@CommonOnUp);
  FMXRectangle[11].OnClick(@CommonOnClick);
  FMXLabel[11].FCreate(FMXRectangle[11].Handle, 'Select components');
  FMXLabel[11].Align(Bottom);
  FMXLabel[11].Height(32);
  FMXLabel[11].FontSetting('Roboto Condensed', 14, ALWhite);
  FMXLabel[11].TextSetting(False, txCenter, txCenter);
  FMXLabel[12].FCreate(FMXRectangle[11].Handle, #$E1EF);
  FMXLabel[12].Align(Contents);
  FMXLabel[12].FontSetting('Segoe UI Symbol', 50, ALWhite);
  FMXLabel[12].TextSetting(False, txCenter, txCenter);

  //Tile Configure installation:
  FMXRectangle[12].FCreate(FMXTabItem[3].Handle);
  FMXRectangle[12].SetBounds(318, 244, 216, 160);
  FMXRectangle[12].FillColor(FMXColor1);
  FMXRectangle[12].CornerStyle(10, 10, [], ctRound);
  FMXRectangle[12].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[12].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[12].OnMouseDown(@CommonOnDown);
  FMXRectangle[12].OnMouseUp(@CommonOnUp);
  FMXRectangle[12].OnClick(@CommonOnClick);
  FMXLabel[13].FCreate(FMXRectangle[12].Handle, 'Configure installation');
  FMXLabel[13].Align(Bottom);
  FMXLabel[13].Height(32);
  FMXLabel[13].FontSetting('Roboto Condensed', 14, ALWhite);
  FMXLabel[13].TextSetting(False, txCenter, txCenter);
  FMXLabel[14].FCreate(FMXRectangle[12].Handle, #$E28F);
  FMXLabel[14].Align(Contents);
  FMXLabel[14].FontSetting('Segoe UI Symbol', 50, ALWhite);
  FMXLabel[14].TextSetting(False, txCenter, txCenter);

  //Tile Start installation:
  FMXRectangle[13].FCreate(FMXTabItem[3].Handle);
  FMXRectangle[13].SetBounds(542, 244, 216, 160);
  FMXRectangle[13].FillColor(FMXColor1);
  FMXRectangle[13].CornerStyle(10, 10, [tcBottomRight], ctRound);
  FMXRectangle[13].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[13].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[13].OnMouseDown(@CommonOnDown);
  FMXRectangle[13].OnMouseUp(@CommonOnUp);
  FMXRectangle[13].OnClick(@CommonOnClick);
  FMXLabel[15].FCreate(FMXRectangle[13].Handle, 'Start installation');
  FMXLabel[15].Align(Bottom);
  FMXLabel[15].Height(32);
  FMXLabel[15].FontSetting('Roboto Condensed', 14, ALWhite);
  FMXLabel[15].TextSetting(False, txCenter, txCenter);
  FMXLabel[16].FCreate(FMXRectangle[13].Handle, #$E184);
  FMXLabel[16].Align(Contents);
  FMXLabel[16].FontSetting('Segoe UI Symbol', 50, ALWhite);
  FMXLabel[16].TextSetting(False, txCenter, txCenter);

  // Title Page:
  FMXTabItem[4].FCreateEx(FMXTabControl[2].Handle);
  FMXTabItem[4].IsSelected(False);

  FMXLayer3D[2].FCreate(FMXViewport3D.Handle);
  FMXLayer3D[2].Projection(pjScreen);
  FMXLayer3D[2].RotationAngle(180, 0, 0);
  FMXLayer3D[2].Resolution(50);
  FMXLayer3D[2].StyleLookup('backgroundstyle');
  FMXLayer3D[2].Transparency(True);
  FMXLayer3D[2].TwoSide(False);
  FMXLayer3D[2].Align(Client);

  FMXFloatAnimation[3].FCreate(FMXLayer3D[2].Handle);
  FMXFloatAnimation[3].Enabled(False);
  FMXFloatAnimation[3].Interpolation(itLinear);
  FMXFloatAnimation[3].AnimationType(atIn, 1, 0, False, False, False);
  FMXFloatAnimation[3].PropertyName('RotationAngle.X');
  FMXFloatAnimation[3].StartFromCurrent(False);
  FMXFloatAnimation[3].SetValues(0, 0);

  FMXFloatAnimation[4].FCreate(FMXLayer3D[2].Handle);
  FMXFloatAnimation[4].Enabled(False);
  FMXFloatAnimation[4].Interpolation(itLinear);
  FMXFloatAnimation[4].AnimationType(atIn, 1, 0, False, False, False);
  FMXFloatAnimation[4].PropertyName('RotationAngle.Y');
  FMXFloatAnimation[4].StartFromCurrent(False);
  FMXFloatAnimation[4].SetValues(0, 0);

  FMXRectangle[14].FCreate(FMXLayer3D[2].Handle);
  FMXRectangle[14].SetBounds(107, 72, 672, 64);
  FMXRectangle[14].FillColor(FMXColor1);
  FMXRectangle[14].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);
  FMXLabel[17].FCreate(FMXRectangle[14].Handle, '');
  FMXLabel[17].Align(Client);
  FMXLabel[17].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[17].TextSetting(False, txLeading, txCenter);
  FMXLabel[18].FCreate(FMXRectangle[14].Handle, '');
  FMXLabel[18].Align(Left);
  FMXLabel[18].Height(64);
  FMXLabel[18].Width(64);
  FMXLabel[18].FontSetting('Segoe UI Symbol', 30, ALWhite);
  FMXLabel[18].TextSetting(False, txCenter, txCenter);

  FMXTabControl[3].FCreate(FMXLayer3D[2].Handle);
  FMXTabControl[3].Align(Contents);
  FMXTabControl[3].Margins(16, 64, 16, 16);
  FMXTabControl[3].Height(432);
  FMXTabControl[3].Width(854);
  FMXTabControl[3].StyleLookup('transparentedit');
  FMXTabControl[3].TabPosition(tpNone);

  // Page Information:
  FMXTabItem[5].FCreateEx(FMXTabControl[3].Handle);
  FMXTabItem[5].IsSelected(False);

  FMXRectangle[15].FCreate(FMXTabItem[5].Handle);
  FMXRectangle[15].SetBounds(91, 80, 672, 168);
  FMXRectangle[15].FillColor(FMXColor1);
  FMXRectangle[15].CornerStyle(10, 10, [tcTopLeft, tcTopRight], ctRound);

  FMXRectangle[16].FCreate(FMXTabItem[5].Handle);
  FMXRectangle[16].SetBounds(91, 248, 616, 56);
  FMXRectangle[16].FillColor(FMXColor1);
  FMXRectangle[16].CornerStyle(-10, -10, [tcBottomRight], ctRound);

  FMXRectangle[17].FCreate(FMXTabItem[5].Handle);
  FMXRectangle[17].SetBounds(707, 248, 56, 56);
  FMXRectangle[17].FillColor(FMXColor1);
  FMXRectangle[17].CornerStyle(10, 10, [tcBottomRight], ctRound);

  FMXRectangle[18].FCreate(FMXTabItem[5].Handle);
  FMXRectangle[18].SetBounds(91, 304, 616, 56);
  FMXRectangle[18].FillColor(FMXColor1);
  FMXRectangle[18].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[19].FCreate(FMXTabItem[5].Handle);
  FMXRectangle[19].SetBounds(107, 96, 584, 213);
  FMXRectangle[19].FillColor(FMXColor2);
  FMXRectangle[19].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXMemo.FCreate(FMXTabItem[5].Handle, False);
  FMXMemo.SetBounds(123, 112, 552, 181);
  FMXMemo.FontSetting('Roboto Condensed', 13, ALWhite);
  FMXMemo.WordWrap(True);
  FMXMemo.ReadOnly(True);
  FMXMemo.ScrollAnimation(True);

  FMXCheckBox.FCreate(FMXTabItem[5].Handle, False, 'I accept the agreement');
  FMXCheckBox.StyledSettings([ssSize, ssStyle]);
  FMXCheckBox.SetBounds(107, 325, 592, 19);
  FMXCheckBox.FontSetting('Roboto Condensed', 13, ALWhite);

  // Page Information Back Button:
  FMXRectangle[20].FCreate(FMXTabItem[5].Handle);
  FMXRectangle[20].SetBounds(714, 312, 48, 48);
  FMXRectangle[20].FillColor(FMXColor1);
  FMXRectangle[20].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[20].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[20].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[20].OnMouseDown(@CommonOnDown);
  FMXRectangle[20].OnMouseUp(@CommonOnUp);
  FMXRectangle[20].OnClick(@CommonOnClick);
  FMXLabel[19].FCreate(FMXRectangle[20].Handle, #$E10B);
  FMXLabel[19].Align(Client);
  FMXLabel[19].FontSetting('Segoe UI Symbol', 24, ALWhite);
  FMXLabel[19].TextSetting(False, txCenter, txCenter);

  // Page App overview:
  FMXTabItem[6].FCreateEx(FMXTabControl[3].Handle);
  FMXTabItem[6].IsSelected(False);

  FMXRectangle[21].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[21].SetBounds(91, 80, 672, 168);
  FMXRectangle[21].FillColor(FMXColor1);
  FMXRectangle[21].CornerStyle(10, 10, [tcTopLeft, tcTopRight], ctRound);

  FMXRectangle[22].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[22].SetBounds(91, 248, 616, 56);
  FMXRectangle[22].FillColor(FMXColor1);
  FMXRectangle[22].CornerStyle(-10, -10, [tcBottomRight], ctRound);

  FMXRectangle[23].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[23].SetBounds(707, 248, 56, 56);
  FMXRectangle[23].FillColor(FMXColor1);
  FMXRectangle[23].CornerStyle(10, 10, [tcBottomRight], ctRound);

  FMXRectangle[24].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[24].SetBounds(91, 304, 616, 56);
  FMXRectangle[24].FillColor(FMXColor1);
  FMXRectangle[24].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[25].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[25].SetBounds(107, 96, 584, 80);
  FMXRectangle[25].FillColor(FMXColor2);
  FMXRectangle[25].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[26].FCreate(FMXRectangle[25].Handle);
  FMXRectangle[26].SetBounds(8, 8, 64, 64);
  FMXRectangle[26].FillPicture(ExtractAndLoad('Icon.png'), wmTileStretch);
  FMXRectangle[26].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[20].FCreate(FMXRectangle[25].Handle, '{#SetupSetting('AppName')}');
  FMXLabel[20].SetBounds(81, 0, 500, 80);
  FMXLabel[20].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[20].TextSetting(False, txLeading, txCenter);

  FMXRectangle[27].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[27].SetBounds(107, 192, 284, 64);
  FMXRectangle[27].FillColor(FMXColor2);
  FMXRectangle[27].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[21].FCreate(FMXRectangle[27].Handle, 'Genre');
  FMXLabel[21].Align(Client);
  FMXLabel[21].Margins(8, 0, 0, 0);
  FMXLabel[21].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[21].TextSetting(False, txLeading, txCenter);

  FMXRectangle[28].FCreate(FMXRectangle[27].Handle);
  FMXRectangle[28].Align(Right);
  FMXRectangle[28].Margins(8, 8, 8, 8);
  FMXRectangle[28].Width(80);
  FMXRectangle[28].FillColor(FMXColor3);
  FMXRectangle[28].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[22].FCreate(FMXRectangle[28].Handle, '{#ReadMInI('ReadString', '/Sec=Game /Key=Genre')}');
  FMXLabel[22].Align(Client);
  FMXLabel[22].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[22].TextSetting(True, txCenter, txCenter);

  FMXRectangle[29].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[29].SetBounds(406, 192, 284, 64);
  FMXRectangle[29].FillColor(FMXColor2);
  FMXRectangle[29].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[23].FCreate(FMXRectangle[29].Handle, 'Rating');
  FMXLabel[23].Align(Client);
  FMXLabel[23].Margins(8, 0, 0, 0);
  FMXLabel[23].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[23].TextSetting(False, txLeading, txCenter);

  FMXRectangle[30].FCreate(FMXRectangle[29].Handle);
  FMXRectangle[30].Align(Right);
  FMXRectangle[30].Margins(8, 8, 8, 8);
  FMXRectangle[30].Width(80);
  FMXRectangle[30].FillColor(FMXColor3);
  FMXRectangle[30].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[24].FCreate(FMXRectangle[30].Handle, '{#ReadMInI('ReadString', '/Sec=Game /Key=Raiting')}');
  FMXLabel[24].Align(Client);
  FMXLabel[24].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[24].TextSetting(True, txCenter, txCenter);

  FMXRectangle[31].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[31].SetBounds(107, 272, 284, 64);
  FMXRectangle[31].FillColor(FMXColor2);
  FMXRectangle[31].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[25].FCreate(FMXRectangle[31].Handle, 'Release date');
  FMXLabel[25].Align(Client);
  FMXLabel[25].Margins(8, 0, 0, 0);
  FMXLabel[25].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[25].TextSetting(False, txLeading, txCenter);

  FMXRectangle[32].FCreate(FMXRectangle[31].Handle);
  FMXRectangle[32].Align(Right);
  FMXRectangle[32].Margins(8, 8, 8, 8);
  FMXRectangle[32].Width(80);
  FMXRectangle[32].FillColor(FMXColor3);
  FMXRectangle[32].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[26].FCreate(FMXRectangle[32].Handle, '{#ReadMInI('ReadString', '/Sec=Game /Key=ReleaseDate')}');
  FMXLabel[26].Align(Client);
  FMXLabel[26].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[26].TextSetting(True, txCenter, txCenter);

  FMXRectangle[33].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[33].SetBounds(406, 272, 284, 64);
  FMXRectangle[33].FillColor(FMXColor2);
  FMXRectangle[33].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[27].FCreate(FMXRectangle[33].Handle, 'Size');
  FMXLabel[27].Align(Client);
  FMXLabel[27].Margins(8, 0, 0, 0);
  FMXLabel[27].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[27].TextSetting(False, txLeading, txCenter);

  FMXRectangle[34].FCreate(FMXRectangle[33].Handle);
  FMXRectangle[34].Align(Right);
  FMXRectangle[34].Margins(8, 8, 8, 8);
  FMXRectangle[34].Width(80);
  FMXRectangle[34].FillColor(FMXColor3);
  FMXRectangle[34].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[28].FCreate(FMXRectangle[34].Handle, MbOrTb({#ReadMInI('ReadString', '/Sec=Game /Key=SizeMB')}, 1));
  FMXLabel[28].Align(Client);
  FMXLabel[28].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[28].TextSetting(True, txCenter, txCenter);

  // Page App overview Back Button:
  FMXRectangle[35].FCreate(FMXTabItem[6].Handle);
  FMXRectangle[35].SetBounds(714, 312, 48, 48);
  FMXRectangle[35].FillColor(FMXColor1);
  FMXRectangle[35].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[35].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[35].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[35].OnMouseDown(@CommonOnDown);
  FMXRectangle[35].OnMouseUp(@CommonOnUp);
  FMXRectangle[35].OnClick(@CommonOnClick);
  FMXLabel[29].FCreate(FMXRectangle[35].Handle, #$E10B);
  FMXLabel[29].Align(Client);
  FMXLabel[29].FontSetting('Segoe UI Symbol', 24, ALWhite);
  FMXLabel[29].TextSetting(False, txCenter, txCenter);

  // Page System requirements:
  FMXTabItem[7].FCreateEx(FMXTabControl[3].Handle);
  FMXTabItem[7].IsSelected(False);

  FMXRectangle[36].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[36].SetBounds(91, 80, 672, 168);
  FMXRectangle[36].FillColor(FMXColor1);
  FMXRectangle[36].CornerStyle(10, 10, [tcTopLeft, tcTopRight], ctRound);

  FMXRectangle[37].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[37].SetBounds(91, 248, 616, 56);
  FMXRectangle[37].FillColor(FMXColor1);
  FMXRectangle[37].CornerStyle(-10, -10, [tcBottomRight], ctRound);

  FMXRectangle[38].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[38].SetBounds(707, 248, 56, 56);
  FMXRectangle[38].FillColor(FMXColor1);
  FMXRectangle[38].CornerStyle(10, 10, [tcBottomRight], ctRound);

  FMXRectangle[39].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[39].SetBounds(91, 304, 616, 56);
  FMXRectangle[39].FillColor(FMXColor1);
  FMXRectangle[39].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[40].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[40].SetBounds(107, 96, 284, 64);
  FMXRectangle[40].FillColor(FMXColor2);
  FMXRectangle[40].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[30].FCreate(FMXRectangle[40].Handle, FMXCpuUsage.Name + ' (' + MHzOrGHz(FMXCpuUsage.Speed, 2) + ')');
  FMXLabel[30].Align(Client);
  FMXLabel[30].Margins(8, 0, 0, 0);
  FMXLabel[30].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[30].TextSetting(True, txLeading, txCenter);

  FMXRectangle[41].FCreate(FMXRectangle[40].Handle);
  FMXRectangle[41].Align(Right);
  FMXRectangle[41].Margins(8, 8, 8, 8);
  FMXRectangle[41].Height(48);
  FMXRectangle[41].Width(48);
  FMXRectangle[41].FillColor(FMXColor3);
  FMXRectangle[41].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[31].FCreate(FMXRectangle[41].Handle, '');
  FMXLabel[31].Align(Client);
  FMXLabel[31].FontSetting('Segoe UI Symbol', 16, ALWhite);
  FMXLabel[31].TextSetting(False, txCenter, txCenter);

  FMXRectangle[42].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[42].SetBounds(406, 96, 284, 64);
  FMXRectangle[42].FillColor(FMXColor2);
  FMXRectangle[42].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[32].FCreate(FMXRectangle[42].Handle, FMXGpuInfo.GPUName + ' (' + MbOrTb(FMXGpuInfo.GPUMemory, 1) + ')');
  FMXLabel[32].Align(Client);
  FMXLabel[32].Margins(8, 0, 0, 0);
  FMXLabel[32].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[32].TextSetting(True, txLeading, txCenter);

  FMXRectangle[43].FCreate(FMXRectangle[42].Handle);
  FMXRectangle[43].Align(Right);
  FMXRectangle[43].Margins(8, 8, 8, 8);
  FMXRectangle[43].Height(48);
  FMXRectangle[43].Width(48);
  FMXRectangle[43].FillColor(FMXColor3);
  FMXRectangle[43].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[33].FCreate(FMXRectangle[43].Handle, '');
  FMXLabel[33].Align(Client);
  FMXLabel[33].FontSetting('Segoe UI Symbol', 16, ALWhite);
  FMXLabel[33].TextSetting(False, txCenter, txCenter);

  FMXRectangle[44].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[44].SetBounds(107, 176, 284, 64);
  FMXRectangle[44].FillColor(FMXColor2);
  FMXRectangle[44].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[34].FCreate(FMXRectangle[44].Handle, MbOrTb(FMXRamUsage.TotalRam, 1) + ' RAM');
  FMXLabel[34].Align(Client);
  FMXLabel[34].Margins(8, 0, 0, 0);
  FMXLabel[34].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[34].TextSetting(True, txLeading, txCenter);

  FMXRectangle[45].FCreate(FMXRectangle[44].Handle);
  FMXRectangle[45].Align(Right);
  FMXRectangle[45].Margins(8, 8, 8, 8);
  FMXRectangle[45].Height(48);
  FMXRectangle[45].Width(48);
  FMXRectangle[45].FillColor(FMXColor3);
  FMXRectangle[45].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[35].FCreate(FMXRectangle[45].Handle, '');
  FMXLabel[35].Align(Client);
  FMXLabel[35].FontSetting('Segoe UI Symbol', 16, ALWhite);
  FMXLabel[35].TextSetting(False, txCenter, txCenter);

  FMXRectangle[46].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[46].SetBounds(406, 176, 284, 64);
  FMXRectangle[46].FillColor(FMXColor2);
  FMXRectangle[46].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[36].FCreate(FMXRectangle[46].Handle, FMXOSInfo.Caption);
  FMXLabel[36].Align(Client);
  FMXLabel[36].Margins(8, 0, 0, 0);
  FMXLabel[36].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[36].TextSetting(True, txLeading, txCenter);

  FMXRectangle[47].FCreate(FMXRectangle[46].Handle);
  FMXRectangle[47].Align(Right);
  FMXRectangle[47].Margins(8, 8, 8, 8);
  FMXRectangle[47].Height(48);
  FMXRectangle[47].Width(48);
  FMXRectangle[47].FillColor(FMXColor3);
  FMXRectangle[47].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[37].FCreate(FMXRectangle[47].Handle, '');
  FMXLabel[37].Align(Client);
  FMXLabel[37].FontSetting('Segoe UI Symbol', 16, ALWhite);
  FMXLabel[37].TextSetting(True, txCenter, txCenter);

  FMXRectangle[48].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[48].SetBounds(107, 264, 584, 80);
  FMXRectangle[48].FillColor(FMXColor2);
  FMXRectangle[48].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[38].FCreate(FMXRectangle[48].Handle, '');
  FMXLabel[38].Align(Client);
  FMXLabel[38].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[38].TextSetting(True, txLeading, txCenter);

  FMXRectangle[49].FCreate(FMXRectangle[48].Handle);
  FMXRectangle[49].Align(Left);
  FMXRectangle[49].Margins(8, 8, 8, 8);
  FMXRectangle[49].Width(64);
  FMXRectangle[49].FillColor(FMXColor3);
  FMXRectangle[49].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[39].FCreate(FMXRectangle[49].Handle, '');
  FMXLabel[39].Align(Client);
  FMXLabel[39].FontSetting('Segoe UI Symbol', 30, ALWhite);
  FMXLabel[39].TextSetting(True, txCenter, txCenter);

  // Page System requirements Back Button:
  FMXRectangle[50].FCreate(FMXTabItem[7].Handle);
  FMXRectangle[50].SetBounds(714, 312, 48, 48);
  FMXRectangle[50].FillColor(FMXColor1);
  FMXRectangle[50].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[50].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[50].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[50].OnMouseDown(@CommonOnDown);
  FMXRectangle[50].OnMouseUp(@CommonOnUp);
  FMXRectangle[50].OnClick(@CommonOnClick);
  FMXLabel[40].FCreate(FMXRectangle[50].Handle, #$E10B);
  FMXLabel[40].Align(Client);
  FMXLabel[40].FontSetting('Segoe UI Symbol', 24, ALWhite);
  FMXLabel[40].TextSetting(True, txCenter, txCenter);

  // Page Selected components:
  FMXTabItem[8].FCreateEx(FMXTabControl[3].Handle);
  FMXTabItem[8].IsSelected(False);

  FMXRectangle[51].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[51].SetBounds(91, 80, 672, 168);
  FMXRectangle[51].FillColor(FMXColor1);
  FMXRectangle[51].CornerStyle(10, 10, [tcTopLeft, tcTopRight], ctRound);

  FMXRectangle[52].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[52].SetBounds(91, 248, 616, 56);
  FMXRectangle[52].FillColor(FMXColor1);
  FMXRectangle[52].CornerStyle(-10, -10, [tcBottomRight], ctRound);

  FMXRectangle[53].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[53].SetBounds(707, 248, 56, 56);
  FMXRectangle[53].FillColor(FMXColor1);
  FMXRectangle[53].CornerStyle(10, 10, [tcBottomRight], ctRound);

  FMXRectangle[54].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[54].SetBounds(91, 304, 616, 56);
  FMXRectangle[54].FillColor(FMXColor1);
  FMXRectangle[54].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[55].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[55].SetBounds(107, 96, 584, 168);
  FMXRectangle[55].FillColor(FMXColor2);
  FMXRectangle[55].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXCheckboxTree.FCreate(FMXRectangle[55].Handle, 16, 16, 552, 136, True);
  FMXCheckboxTree.OverrideDefaultOnChangeEvents;
  FMXCheckboxTree.SmoothScroll(True);

#if MAX_REDIST > 0
  SectionRedist:= FMXCheckboxTree.AddEmptySection('Redistributables packs', Longint(FMXCheckboxTree.BaseHandle));
  FMXCheckboxTree.SectionFontSetting(SectionRedist, 'Roboto Condensed', 14, ALWhite);
#sub InitRedists
  #define SubSec ReadMInI('GetSubSection', '/MainSec=Redists /Idx=' + Str(i) + ' /RootOnly=true')
  #if SubSec != ""
  RedistData[{#i} + 1].Caption:= '{#ReadMInI('ReadSubString', '/MainSec=Redists /SubSec=' + SubSec + ' /Key=Name')}';
  RedistData[{#i} + 1].FileName:= ExpandConstant('{#ReadMInI('ReadSubString', '/MainSec=Redists /SubSec=' + SubSec + ' /Key=File')}');
  RedistData[{#i} + 1].Args:= '{#ReadMInI('ReadSubString', '/MainSec=Redists /SubSec=' + SubSec + ' /Key=Args')}';

  RedistCheckBox[{#i} + 1]:= FMXCheckboxTree.AddCheckBox(RedistData[{#i} + 1].Caption, SectionRedist, False);
  FMXCheckboxTree.CheckboxSetWidth(RedistCheckBox[{#i} + 1], 530);
  FMXCheckboxTree.CheckBoxFontSetting(RedistCheckBox[{#i} + 1], 'Roboto Condensed', 14, ALWhite);
  #endif
#endsub
#for {i = 0; i < MAX_REDIST; i++} InitRedists
#endif

#if MAX_COMPO > 0
  SectionCompo:= FMXCheckboxTree.AddEmptySection('DLC pack', Longint(FMXCheckboxTree.BaseHandle));
  FMXCheckboxTree.SectionFontSetting(SectionCompo, 'Roboto Condensed', 14, ALWhite);
#sub InitCompos
  #define CompoSubSec ReadMInI('GetSubSection', '/MainSec=Compos /Idx=' + Str(i) + ' /RootOnly=true')
  #if CompoSubSec != ""
  CompoData[{#i} + 1].Caption:= '{#ReadMInI('ReadSubString', '/MainSec=Compos /SubSec=' + CompoSubSec + ' /Key=Name')}';
  CompoData[{#i} + 1].FileName:= ExpandConstant('{#ReadMInI('ReadSubString', '/MainSec=Compos /SubSec=' + CompoSubSec + ' /Key=File')}');
  CompoData[{#i} + 1].SizeMB := StrToInt(ExpandConstant('{#ReadMInI('ReadSubString', '/MainSec=Compos /SubSec=' + CompoSubSec + ' /Key=SizeMB')}'));
  CompoData[{#i} + 1].SizeTxt := '  [{#ReadMInI('ReadSubString', '/MainSec=Compos /SubSec=' + CompoSubSec + ' /Key=SizeMB')} MB]';

  CompoCheckBox[{#i} + 1]:= FMXCheckboxTree.AddCheckBox(CompoData[{#i} + 1].Caption + CompoData[{#i} + 1].SizeTxt, SectionCompo, False);
  FMXCheckboxTree.CheckboxSetWidth(CompoCheckBox[{#i} + 1], 530);
  FMXCheckboxTree.CheckBoxFontSetting(CompoCheckBox[{#i} + 1], 'Roboto Condensed', 14, ALWhite);
  FMXCheckboxTree.CheckBoxOnChange(CompoCheckBox[{#i} + 1], @CalculateSize);
  #endif
#endsub
#for {i = 0; i < MAX_COMPO; i++} InitCompos
#endif

  FMXRectangle[56].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[56].SetBounds(107, 272, 184, 64);
  FMXRectangle[56].FillColor(FMXColor2);
  FMXRectangle[56].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[41].FCreate(FMXRectangle[56].Handle, 'Space required');
  FMXLabel[41].Align(Client);
  FMXLabel[41].Margins(8, 0, 0, 0);
  FMXLabel[41].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[41].TextSetting(True, txLeading, txCenter);

  FMXRectangle[57].FCreate(FMXRectangle[56].Handle);
  FMXRectangle[57].Align(Right);
  FMXRectangle[57].Margins(8, 8, 8, 8);
  FMXRectangle[57].Width(80);
  FMXRectangle[57].FillColor(FMXColor3);
  FMXRectangle[57].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[42].FCreate(FMXRectangle[57].Handle, MbOrTb({#ReadMInI('ReadString', '/Sec=Game /Key=SizeMB')}, 1));
  FMXLabel[42].Align(Client);
  FMXLabel[42].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[42].TextSetting(True, txCenter, txCenter);

  FMXRectangle[58].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[58].SetBounds(307, 272, 184, 64);
  FMXRectangle[58].FillColor(FMXColor2);
  FMXRectangle[58].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[43].FCreate(FMXRectangle[58].Handle, 'Space available');
  FMXLabel[43].Align(Client);
  FMXLabel[43].Margins(8, 0, 0, 0);
  FMXLabel[43].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[43].TextSetting(True, txLeading, txCenter);

  FMXRectangle[59].FCreate(FMXRectangle[58].Handle);
  FMXRectangle[59].Align(Right);
  FMXRectangle[59].Margins(8, 8, 8, 8);
  FMXRectangle[59].Width(80);
  FMXRectangle[59].FillColor(FMXColor3);
  FMXRectangle[59].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[44].FCreate(FMXRectangle[59].Handle, '00 MB');
  FMXLabel[44].Align(Client);
  FMXLabel[44].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[44].TextSetting(True, txCenter, txCenter);

  FMXRectangle[60].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[60].SetBounds(507, 272, 184, 64);
  FMXRectangle[60].FillColor(FMXColor2);
  FMXRectangle[60].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[45].FCreate(FMXRectangle[60].Handle, 'Enough Space');
  FMXLabel[45].Align(Client);
  FMXLabel[45].Margins(8, 0, 0, 0);
  FMXLabel[45].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[45].TextSetting(True, txLeading, txCenter);

  FMXRectangle[61].FCreate(FMXRectangle[60].Handle);
  FMXRectangle[61].Align(Right);
  FMXRectangle[61].Margins(8, 8, 8, 8);
  FMXRectangle[61].Width(80);
  FMXRectangle[61].FillColor(FMXColor3);
  FMXRectangle[61].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[46].FCreate(FMXRectangle[61].Handle, #$E10B);
  FMXLabel[46].Align(Client);
  FMXLabel[46].FontSetting('Segoe UI Symbol', 16, ALWhite);
  FMXLabel[46].TextSetting(True, txCenter, txCenter);

  // Page System requirements Back Button:
  FMXRectangle[62].FCreate(FMXTabItem[8].Handle);
  FMXRectangle[62].SetBounds(714, 312, 48, 48);
  FMXRectangle[62].FillColor(FMXColor1);
  FMXRectangle[62].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[62].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[62].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[62].OnMouseDown(@CommonOnDown);
  FMXRectangle[62].OnMouseUp(@CommonOnUp);
  FMXRectangle[62].OnClick(@CommonOnClick);
  FMXLabel[47].FCreate(FMXRectangle[62].Handle, #$E10B);
  FMXLabel[47].Align(Client);
  FMXLabel[47].FontSetting('Segoe UI Symbol', 24, ALWhite);
  FMXLabel[47].TextSetting(True, txCenter, txCenter);

  // Page Configure installation:
  FMXTabItem[9].FCreateEx(FMXTabControl[3].Handle);
  FMXTabItem[9].IsSelected(False);

  FMXRectangle[63].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[63].SetBounds(91, 80, 672, 168);
  FMXRectangle[63].FillColor(FMXColor1);
  FMXRectangle[63].CornerStyle(10, 10, [tcTopLeft, tcTopRight], ctRound);

  FMXRectangle[64].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[64].SetBounds(91, 248, 616, 56);
  FMXRectangle[64].FillColor(FMXColor1);
  FMXRectangle[64].CornerStyle(-10, -10, [tcBottomRight], ctRound);

  FMXRectangle[65].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[65].SetBounds(707, 248, 56, 56);
  FMXRectangle[65].FillColor(FMXColor1);
  FMXRectangle[65].CornerStyle(10, 10, [tcBottomRight], ctRound);

  FMXRectangle[66].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[66].SetBounds(91, 304, 616, 56);
  FMXRectangle[66].FillColor(FMXColor1);
  FMXRectangle[66].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[67].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[67].SetBounds(107, 96, 584, 64);
  FMXRectangle[67].FillColor(FMXColor2);
  FMXRectangle[67].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[48].FCreate(FMXRectangle[67].Handle, 'Installation directory');
  FMXLabel[48].Align(Left);
  FMXLabel[48].Margins(8, 0, 8, 0);
  FMXLabel[48].Width(145);
  FMXLabel[48].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[48].TextSetting(True, txLeading, txCenter);

  FMXRectangle[68].FCreate(FMXRectangle[67].Handle);
  FMXRectangle[68].Align(Client);
  FMXRectangle[68].Margins(8, 8, 8, 8);
  FMXRectangle[68].Width(407);
  FMXRectangle[68].FillColor(FMXColor3);
  FMXRectangle[68].CornerStyle(10, 10, [tcTopLeft, tcTopRight,tcBottomLeft, tcBottomRight], ctRound);

  FMXEdit.FCreate(FMXRectangle[68].Handle);
  FMXEdit.Align(Client);
  FMXEdit.Margins(8, 8, 8, 8);
  FMXEdit.Height(32);
  FMXEdit.Width(391);
  FMXEdit.StyledSettings([ssStyle]);
  FMXEdit.StyleLookup('transparentedit');
  FMXEdit.ReadOnly(True);
  FMXEdit.Text(MinimizePathName(WizardForm.DirEdit.Text, WizardForm.DirEdit.Font, WizardForm.DirEdit.Width - 60));
  FMXEdit.FontSetting('Roboto Condensed', 16, ALWhite);
  FMXEdit.AddSearchButton(@CommonOnClick);

  FMXRectangle[69].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[69].SetBounds(107, 172, 184, 64);
  FMXRectangle[69].FillColor(FMXColor2);
  FMXRectangle[69].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[49].FCreate(FMXRectangle[69].Handle, 'Space required');
  FMXLabel[49].Align(Client);
  FMXLabel[49].Margins(8, 0, 0, 0);
  FMXLabel[49].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[49].TextSetting(True, txLeading, txCenter);

  FMXRectangle[70].FCreate(FMXRectangle[69].Handle);
  FMXRectangle[70].Align(Right);
  FMXRectangle[70].Margins(8, 8, 8, 8);
  FMXRectangle[70].Width(80);
  FMXRectangle[70].FillColor(FMXColor3);
  FMXRectangle[70].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[50].FCreate(FMXRectangle[70].Handle, MbOrTb({#ReadMInI('ReadString', '/Sec=Game /Key=SizeMB')}, 1));
  FMXLabel[50].Align(Client);
  FMXLabel[50].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[50].TextSetting(True, txCenter, txCenter);

  FMXRectangle[71].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[71].SetBounds(307, 172, 184, 64);
  FMXRectangle[71].FillColor(FMXColor2);
  FMXRectangle[71].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[51].FCreate(FMXRectangle[71].Handle, 'Space available');
  FMXLabel[51].Align(Client);
  FMXLabel[51].Margins(8, 0, 0, 0);
  FMXLabel[51].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[51].TextSetting(True, txLeading, txCenter);

  FMXRectangle[72].FCreate(FMXRectangle[71].Handle);
  FMXRectangle[72].Align(Right);
  FMXRectangle[72].Margins(8, 8, 8, 8);
  FMXRectangle[72].Width(80);
  FMXRectangle[72].FillColor(FMXColor3);
  FMXRectangle[72].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[52].FCreate(FMXRectangle[72].Handle, '00 MB');
  FMXLabel[52].Align(Client);
  FMXLabel[52].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[52].TextSetting(True, txCenter, txCenter);

  FMXRectangle[73].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[73].SetBounds(507, 172, 184, 64);
  FMXRectangle[73].FillColor(FMXColor2);
  FMXRectangle[73].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[53].FCreate(FMXRectangle[73].Handle, 'Enough Space');
  FMXLabel[53].Align(Client);
  FMXLabel[53].Margins(8, 0, 0, 0);
  FMXLabel[53].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[53].TextSetting(True, txLeading, txCenter);

  FMXRectangle[74].FCreate(FMXRectangle[73].Handle);
  FMXRectangle[74].Align(Right);
  FMXRectangle[74].Margins(8, 8, 8, 8);
  FMXRectangle[74].Width(80);
  FMXRectangle[74].FillColor(FMXColor3);
  FMXRectangle[74].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[54].FCreate(FMXRectangle[74].Handle, #$E10B);
  FMXLabel[54].Align(Client);
  FMXLabel[54].FontSetting('Segoe UI Symbol', 16, ALWhite);
  FMXLabel[54].TextSetting(True, txCenter, txCenter);

#if MAX_ICONS > 0
  FMXCheckBoxIcons[1].FCreate(FMXTabItem[9].Handle, True, 'Create desktop icons');
  FMXCheckBoxIcons[1].SetBounds(108, 252, 400, 19);
  FMXCheckBoxIcons[1].FontSetting('Roboto Condensed', 15, ALWhite);

  FMXCheckBoxIcons[2].FCreate(FMXTabItem[9].Handle, True, 'Create Start Menu folder');
  FMXCheckBoxIcons[2].SetBounds(108, 282, 400, 19);
  FMXCheckBoxIcons[2].FontSetting('Roboto Condensed', 15, ALWhite);
#endif

  // Page Configure installation Back Button:
  FMXRectangle[75].FCreate(FMXTabItem[9].Handle);
  FMXRectangle[75].SetBounds(714, 312, 48, 48);
  FMXRectangle[75].FillColor(FMXColor1);
  FMXRectangle[75].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[75].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[75].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[75].OnMouseDown(@CommonOnDown);
  FMXRectangle[75].OnMouseUp(@CommonOnUp);
  FMXRectangle[75].OnClick(@CommonOnClick);
  FMXLabel[55].FCreate(FMXRectangle[75].Handle, #$E10B);
  FMXLabel[55].Align(Client);
  FMXLabel[55].FontSetting('Segoe UI Symbol', 24, ALWhite);
  FMXLabel[55].TextSetting(True, txCenter, txCenter);

  // Page Start installation:
  FMXTabItem[10].FCreateEx(FMXTabControl[3].Handle);
  FMXTabItem[10].IsSelected(False);

  FMXRectangle[76].FCreate(FMXTabItem[10].Handle);
  FMXRectangle[76].SetBounds(91, 80, 672, 216);
  FMXRectangle[76].FillColor(FMXColor1);
  FMXRectangle[76].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[77].FCreate(FMXTabItem[10].Handle);
  FMXRectangle[77].SetBounds(107, 96, 308, 56);
  FMXRectangle[77].FillColor(FMXColor2);
  FMXRectangle[77].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[56].FCreate(FMXRectangle[77].Handle, 'Elapsed time');
  FMXLabel[56].Align(Left);
  FMXLabel[56].Margins(8, 0, 8, 0);
  FMXLabel[56].Width(92);
  FMXLabel[56].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[56].TextSetting(True, txLeading, txCenter);

  FMXRectangle[78].FCreate(FMXRectangle[77].Handle);
  FMXRectangle[78].Align(Right);
  FMXRectangle[78].Margins(8, 8, 8, 8);
  FMXRectangle[78].Width(184);
  FMXRectangle[78].FillColor(FMXColor3);
  FMXRectangle[78].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[57].FCreate(FMXRectangle[78].Handle, '00 seconds');
  FMXLabel[57].Align(Client);
  FMXLabel[57].Margins(8, 8, 8, 8);
  FMXLabel[57].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[57].TextSetting(True, txCenter, txCenter);

  FMXRectangle[79].FCreate(FMXTabItem[10].Handle);
  FMXRectangle[79].SetBounds(432, 96, 308, 56);
  FMXRectangle[79].FillColor(FMXColor2);
  FMXRectangle[79].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[58].FCreate(FMXRectangle[79].Handle, 'Remaining time');
  FMXLabel[58].Align(Left);
  FMXLabel[58].Margins(8, 0, 8, 0);
  FMXLabel[58].Width(92);
  FMXLabel[58].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[58].TextSetting(True, txLeading, txCenter);

  FMXRectangle[80].FCreate(FMXRectangle[79].Handle);
  FMXRectangle[80].Align(Right);
  FMXRectangle[80].FillColor(FMXColor3);
  FMXRectangle[80].Margins(8, 8, 8, 8);
  FMXRectangle[80].Width(184);
  FMXRectangle[80].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[59].FCreate(FMXRectangle[80].Handle, '00 seconds');
  FMXLabel[59].Align(Client);
  FMXLabel[59].Margins(8, 8, 8, 8);
  FMXLabel[59].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[59].TextSetting(True, txCenter, txCenter);

  FMXRectangle[81].FCreate(FMXTabItem[10].Handle);
  FMXRectangle[81].SetBounds(107, 168, 308, 56);
  FMXRectangle[81].FillColor(FMXColor2);
  FMXRectangle[81].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[60].FCreate(FMXRectangle[81].Handle, 'Transferred');
  FMXLabel[60].Align(Left);
  FMXLabel[60].Margins(8, 0, 8, 0);
  FMXLabel[60].Width(92);
  FMXLabel[60].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[60].TextSetting(True, txLeading, txCenter);

  FMXRectangle[82].FCreate(FMXRectangle[81].Handle);
  FMXRectangle[82].Align(Client);
  FMXRectangle[82].Margins(8, 8, 8, 8);
  FMXRectangle[82].Width(184);
  FMXRectangle[82].FillColor(FMXColor3);
  FMXRectangle[82].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[61].FCreate(FMXRectangle[82].Handle, '00 MB');
  FMXLabel[61].Align(Client);
  FMXLabel[61].Margins(8, 8, 8, 8);
  FMXLabel[61].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[61].TextSetting(True, txCenter, txCenter);

  FMXRectangle[83].FCreate(FMXTabItem[10].Handle);
  FMXRectangle[83].SetBounds(432, 168, 308, 56);
  FMXRectangle[83].FillColor(FMXColor2);
  FMXRectangle[83].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[62].FCreate(FMXRectangle[83].Handle, 'Total');
  FMXLabel[62].Align(Left);
  FMXLabel[62].Margins(8, 0, 8, 0);
  FMXLabel[62].Width(92);
  FMXLabel[62].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[62].TextSetting(True, txLeading, txCenter);

  FMXRectangle[84].FCreate(FMXRectangle[83].Handle);
  FMXRectangle[84].Align(Client);
  FMXRectangle[84].FillColor(FMXColor3);
  FMXRectangle[84].Margins(8, 8, 8, 8);
  FMXRectangle[84].Width(184);
  FMXRectangle[84].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[63].FCreate(FMXRectangle[84].Handle, '00 MB');
  FMXLabel[63].Align(Client);
  FMXLabel[63].Margins(8, 8, 8, 8);
  FMXLabel[63].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[63].TextSetting(True, txCenter, txCenter);

  FMXProgressBar.FCreate(FMXTabItem[10].Handle, 117, 267, 522, 1, ALNull, ALNull, True);
  FMXProgressBar.IndicatorOpacity(0, 0);

  FMXArc[1].FCreate(FMXProgressBar.IndicatorHandle);
  FMXArc[1].Height(128);
  FMXArc[1].Width(128);
  FMXArc[1].FillColor(FMXColor1);
  FMXArc[1].StrokeSetting(0, scFlat, sdSolid, sjMiter);
  FMXArc[1].StartAngle(0);
  FMXArc[1].EndAngle(180);

  FMXCircle[1].FCreate(FMXArc[1].Handle);
  FMXCircle[1].Align(Client);
  FMXCircle[1].Margins(8, 8, 8, 8);
  FMXCircle[1].Height(112);
  FMXCircle[1].Width(112);
  FMXCircle[1].FillColor(FMXColor2);
  FMXCircle[1].StrokeSetting(0, scFlat, sdSolid, sjMiter);

  FMXLabel[64].FCreate(FMXCircle[1].Handle, '0%');
  FMXLabel[64].Align(Client);
  FMXLabel[64].FontSetting('Roboto Lt', 28, ALWhite);
  FMXLabel[64].TextSetting(True, txCenter, txCenter);

  FMXCircle[2].FCreate(FMXCircle[1].Handle);
  FMXCircle[2].Align(Client);
  FMXCircle[2].Margins(8, 8, 8, 8);
  FMXCircle[2].Height(96);
  FMXCircle[2].Width(96);
  FMXCircle[2].FillColor(ALNull);
  FMXCircle[2].StrokeColor(FMXColor3);
  FMXCircle[2].StrokeSetting(6, scFlat, sdSolid, sjMiter);
  
  // Page Finished:
  FMXTabItem[11].FCreateEx(FMXTabControl[2].Handle);
  FMXTabItem[11].IsSelected(False);

  FMXRectangle[85].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[85].SetBounds(91, 56, 672, 64);
  FMXRectangle[85].FillColor(FMXColor1);
  FMXRectangle[85].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[65].FCreate(FMXRectangle[85].Handle, 'Finished');
  FMXLabel[65].Align(Client);
  FMXLabel[65].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[65].TextSetting(True, txLeading, txCenter);

  FMXLabel[66].FCreate(FMXRectangle[85].Handle, #$E10B);
  FMXLabel[66].Align(Left);
  FMXLabel[66].Height(64);
  FMXLabel[66].Width(64);
  FMXLabel[66].FontSetting('Segoe UI Symbol', 30, ALWhite);
  FMXLabel[66].TextSetting(True, txCenter, txCenter);

  FMXRectangle[86].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[86].SetBounds(91, 128, 672, 168);
  FMXRectangle[86].FillColor(FMXColor1);
  FMXRectangle[86].CornerStyle(10, 10, [tcTopLeft, tcTopRight], ctRound);

  FMXRectangle[87].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[87].SetBounds(91, 296, 616, 56);
  FMXRectangle[87].FillColor(FMXColor1);
  FMXRectangle[87].CornerStyle(-10, -10, [tcBottomRight], ctRound);

  FMXRectangle[88].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[88].SetBounds(707, 296, 56, 56);
  FMXRectangle[88].FillColor(FMXColor1);
  FMXRectangle[88].CornerStyle(10, 10, [tcBottomRight], ctRound);

  FMXRectangle[89].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[89].SetBounds(91, 352, 616, 56);
  FMXRectangle[89].FillColor(FMXColor1);
  FMXRectangle[89].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[90].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[90].SetBounds(107, 144, 584, 80);
  FMXRectangle[90].FillColor(FMXColor2);
  FMXRectangle[90].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXRectangle[91].FCreate(FMXRectangle[90].Handle);
  FMXRectangle[91].SetBounds(8, 8, 64, 64);
  FMXRectangle[91].FillPicture(ExtractAndLoad('Icon.png'), wmTileStretch);
  FMXRectangle[91].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[67].FCreate(FMXRectangle[90].Handle, '{#SetupSetting('AppName')}');
  FMXLabel[67].SetBounds(81, 0, 500, 80);
  FMXLabel[67].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[67].TextSetting(False, txLeading, txCenter);

  FMXRectangle[92].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[92].SetBounds(107, 240, 284, 64);
  FMXRectangle[92].FillColor(FMXColor2);
  FMXRectangle[92].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[68].FCreate(FMXRectangle[92].Handle, 'Status');
  FMXLabel[68].Align(Client);
  FMXLabel[68].Margins(8, 0, 0, 0);
  FMXLabel[68].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[68].TextSetting(False, txLeading, txCenter);

  FMXRectangle[93].FCreate(FMXRectangle[92].Handle);
  FMXRectangle[93].Align(Right);
  FMXRectangle[93].Margins(8, 8, 8, 8);
  FMXRectangle[93].Width(154);
  FMXRectangle[93].FillColor(FMXColor3);
  FMXRectangle[93].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[69].FCreate(FMXRectangle[93].Handle, 'Success!');
  FMXLabel[69].Align(Client);
  FMXLabel[69].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[69].TextSetting(True, txCenter, txCenter);

  FMXRectangle[94].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[94].SetBounds(407, 240, 284, 64);
  FMXRectangle[94].FillColor(FMXColor2);
  FMXRectangle[94].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[70].FCreate(FMXRectangle[94].Handle, 'All elapsed time');
  FMXLabel[70].Align(Client);
  FMXLabel[70].Margins(8, 0, 0, 0);
  FMXLabel[70].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[70].TextSetting(False, txLeading, txCenter);

  FMXRectangle[95].FCreate(FMXRectangle[94].Handle);
  FMXRectangle[95].Align(Right);
  FMXRectangle[95].Margins(8, 8, 8, 8);
  FMXRectangle[95].Width(154);
  FMXRectangle[95].FillColor(FMXColor3);
  FMXRectangle[95].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[71].FCreate(FMXRectangle[95].Handle, '00 seconds');
  FMXLabel[71].Align(Client);
  FMXLabel[71].FontSetting('Roboto Condensed', 15, ALWhite);
  FMXLabel[71].TextSetting(True, txCenter, txCenter);

  FMXLabel[72].FCreate(FMXTabItem[11].Handle, 'Successfully installed on your PC');
  FMXLabel[72].SetBounds(108, 340, 400, 19);
  FMXLabel[72].FontSetting('Roboto Condensed', 16, ALWhite);
  FMXLabel[72].TextSetting(True, txLeading, txCenter);
  // Exit Button:
  FMXRectangle[96].FCreate(FMXTabItem[11].Handle);
  FMXRectangle[96].SetBounds(714, 360, 48, 48);
  FMXRectangle[96].FillColor(FMXColor1);
  FMXRectangle[96].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[96].OnMouseEnter(@CommonOnEnter);
  FMXRectangle[96].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[96].OnMouseDown(@CommonOnDown);
  FMXRectangle[96].OnMouseUp(@CommonOnUp);
  FMXRectangle[96].OnClick(@CommonOnClick);
  FMXLabel[73].FCreate(FMXRectangle[96].Handle, #$E10A);
  FMXLabel[73].Align(Client);
  FMXLabel[73].FontSetting('Segoe UI Symbol', 24, ALWhite);
  FMXLabel[73].TextSetting(True, txCenter, txCenter);

  // Mini Form:
  FMXTabItem[2].FCreateEx(FMXTabControl[1].Handle);
  FMXTabItem[2].IsSelected(False);

  FMXRectangle[97].FCreate(FMXTabItem[2].Handle);
  FMXRectangle[97].Align(Center);
  FMXRectangle[97].Height(136);
  FMXRectangle[97].Width(406);
  FMXRectangle[97].FillColor(FMXColor1);
  FMXRectangle[97].StrokeSetting(0, scFlat, sdSolid, sjMiter);
  FMXRectangle[97].CornerStyle(20, 20, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXCircle[3].FCreate(FMXRectangle[97].Handle);
  FMXCircle[3].Align(Left);
  FMXCircle[3].Margins(8, 8, 8, 8);
  FMXCircle[3].Height(80);
  FMXCircle[3].Width(80);
  FMXCircle[3].FillColor(FMXColor2);
  FMXCircle[3].StrokeSetting(0, scFlat, sdSolid, sjMiter);

  FMXLabel[74].FCreate(FMXCircle[3].Handle, '0%');
  FMXLabel[74].Align(Client);
  FMXLabel[74].FontSetting('Roboto Lt', 22, ALWhite);
  FMXLabel[74].TextSetting(True, txCenter, txCenter);

  FMXArc[2].FCreate(FMXCircle[3].Handle);
  FMXArc[2].Align(Client);
  FMXArc[2].Margins(8, 8, 8, 8);
  FMXArc[2].Height(64);
  FMXArc[2].Width(64);
  FMXArc[2].StrokeColor(FMXColor3);
  FMXArc[2].StrokeSetting(3, scFlat, sdSolid, sjMiter);
  FMXArc[2].StartAngle(-90);
  FMXArc[2].EndAngle(60);

  // Mini Form Back Button:
  FMXCircle[4].FCreate(FMXRectangle[97].Handle);
  FMXCircle[4].Align(Right);
  FMXCircle[4].Margins(8, 8, 8, 8);
  FMXCircle[4].Height(80);
  FMXCircle[4].Width(80);
  FMXCircle[4].FillColor(FMXColor2);
  FMXCircle[4].StrokeSetting(0, scFlat, sdSolid, sjMiter);
  FMXCircle[5].FCreate(FMXCircle[4].Handle);
  FMXCircle[5].Align(Client);
  FMXCircle[5].Margins(8, 8, 8, 8);
  FMXCircle[5].Height(64);
  FMXCircle[5].Width(64);
  FMXCircle[5].FillColor(ALNull);
  FMXCircle[5].StrokeColor(FMXColor3);
  FMXCircle[5].StrokeSetting(3, scFlat, sdSolid, sjMiter);
  FMXCircle[5].OnMouseEnter(@CommonOnEnter);
  FMXCircle[5].OnMouseLeave(@CommonOnLeave);
  FMXCircle[5].OnMouseDown(@CommonOnDown);
  FMXCircle[5].OnMouseUp(@CommonOnUp);
  FMXCircle[5].OnClick(@CommonOnClick);
  FMXLabel[75].FCreate(FMXCircle[5].Handle, #$E1D9);
  FMXLabel[75].Align(Client);
  FMXLabel[75].FontSetting('Segoe UI Symbol', 18, ALWhite);
  FMXLabel[75].TextSetting(True, txCenter, txCenter);

  // Mini Form Title Bar:
  FMXRectangle[98].FCreate(FMXRectangle[97].Handle);
  FMXRectangle[98].Align(MostTop);
  FMXRectangle[98].Margins(16, 0, 16, 0);
  FMXRectangle[98].Height(40);
  FMXRectangle[98].Width(374);
  FMXRectangle[98].FillColor(FMXColor2);
  FMXRectangle[98].CornerStyle(10, 10, [tcBottomLeft, tcBottomRight], ctRound);
  FMXRectangle[98].OnMouseLeave(@CommonOnLeave);
  FMXRectangle[98].OnMouseDown(@CommonOnDown);
  FMXRectangle[98].OnMouseUp(@CommonOnUp);
  FMXRectangle[98].OnMouseMove(@CommonOnMove);
  FMXLabel[76].FCreate(FMXRectangle[98].Handle, 'Setup - {#SetupSetting('AppName')}');
  FMXLabel[76].Align(Client);
  FMXLabel[76].Margins(16, 0, 16, 0);
  FMXLabel[76].FontSetting('Roboto Condensed', 17, ALWhite);
  FMXLabel[76].TextSetting(True, txLeading, txCenter);

  FMXRectangle[99].FCreate(FMXRectangle[97].Handle);
  FMXRectangle[99].Align(Client);
  FMXRectangle[99].Margins(8, 24, 8, 24);
  FMXRectangle[99].Height(48);
  FMXRectangle[99].Width(198);
  FMXRectangle[99].FillColor(FMXColor2);
  FMXRectangle[99].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[77].FCreate(FMXRectangle[99].Handle, 'Remaining time');
  FMXLabel[77].Align(Left);
  FMXLabel[77].Margins(8, 0, 8, 0);
  FMXLabel[77].Height(48);
  FMXLabel[77].Width(81);
  FMXLabel[77].FontSetting('Roboto Condensed', 13, ALWhite);
  FMXLabel[77].TextSetting(True, txLeading, txCenter);

  FMXRectangle[100].FCreate(FMXRectangle[99].Handle);
  FMXRectangle[100].Align(Client);
  FMXRectangle[100].Margins(8, 8, 8, 8);
  FMXRectangle[100].Height(32);
  FMXRectangle[100].Width(85);
  FMXRectangle[100].FillColor(FMXColor3);
  FMXRectangle[100].CornerStyle(10, 10, [tcTopLeft, tcTopRight, tcBottomLeft, tcBottomRight], ctRound);

  FMXLabel[78].FCreate(FMXRectangle[100].Handle, '00 seconds');
  FMXLabel[78].Align(Client);
  FMXLabel[78].Margins(8, 8, 8, 8);
  FMXLabel[78].FontSetting('Roboto Condensed', 13, ALWhite);
  FMXLabel[78].TextSetting(True, txCenter, txCenter);
end;

procedure InitializeWizard();
begin
  EmptyWizardForm(True, 918, 584);

  FMXDesigning;
  FMXForm.Show;

  pTaskbarPreviewEx(FMXForm.HandleHWND, True);
end;

procedure CheckComponents;
var
  i: Integer;
begin
  if FileExists(ExpandConstant('{src}\license.txt')) then
  begin
    FMXMemo.LoadFromfile(ExpandConstant('{src}\license.txt'));
    FMXRectangle[8].Enabled(True);
  end;

  if {#ReadMInI('ReadString', '/Sec=Game /Key=CPUSpeed')} <= FMXCpuUsage.Speed then
    FMXLabel[31].Text(#$E10B)
  else
  begin
    FMXLabel[31].Text(#$E10A);
    RequirementsOK:= True;
  end;

  if {#ReadMInI('ReadString', '/Sec=Game /Key=GPURAM')} <= FMXGpuInfo.GPUMemory then
    FMXLabel[33].Text(#$E10B)
  else
  begin
    FMXLabel[33].Text(#$E10A);
    RequirementsOK:= True;
  end;

  if {#ReadMInI('ReadString', '/Sec=Game /Key=RAM')} <= FMXRamUsage.TotalRam then
    FMXLabel[35].Text(#$E10B)
  else
  begin
    FMXLabel[35].Text(#$E10A);
    RequirementsOK:= True;
  end;

  if {#ReadMInI('ReadString', '/Sec=Game /Key=OSBuild')} <= GetWinBuildNumber then
    FMXLabel[37].Text(#$E10B)
  else
  begin
    FMXLabel[37].Text(#$E10A);
    RequirementsOK:= True;
  end;

  if RequirementsOK = True then
  begin
    FMXLabel[38].Text('Your system is not supported');
    FMXLabel[39].Text(#$E10A);
  end else
  begin
    FMXLabel[38].Text('Your system is supported');
    FMXLabel[39].Text(#$E10B);
  end;

#if MAX_REDIST > 0
  for i:= 1 to GetArrayLength(RedistData) do
  if not FileExists(RedistData[i].FileName) then
  begin
    FMXCheckboxTree.CheckBoxSetChecked(RedistCheckBox[i], False);
    FMXCheckboxTree.CheckboxEnable(RedistCheckBox[i], False);
  end;
#endif

#if MAX_COMPO > 0
  for i:= 1 to GetArrayLength(CompoData) do
  if not FileExists(CompoData[i].FileName) then
  begin
    FMXCheckboxTree.CheckBoxSetChecked(CompoCheckBox[i], False);
    FMXCheckboxTree.CheckboxEnable(CompoCheckBox[i], False);
  end;
#endif
end;

procedure ShowComponents(CurPageID: Integer);
begin
  case CurPageID of

    wpSelectDir:
    begin
      CalculateSize(nil);
    end;

    wpFinished:
    begin
      if ISArcExError then
      begin
        FMXLabel[65].Text('Error');
        FMXLabel[66].Text(#$E10A);
        FMXLabel[69].Text('Error');
        FMXLabel[72].Text('Not installed on your PC');
      end;

      FMXTabItem[11].IsSelected(True);

      FMXLayer3D[1].RotationAngle(0, 180, 0);
      FMXLayer3D[2].RotationAngle(0, 0, 0);

      FMXFloatAnimation[2].StopAtCurrent;
      FMXFloatAnimation[2].SetValues(180, 360);
      FMXFloatAnimation[2].Start;
      FMXFloatAnimation[4].StopAtCurrent;
      FMXFloatAnimation[4].SetValues(0, 180);
      FMXFloatAnimation[4].Start;

      FMXLayer3D[2].BringToFront;
    end;

  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  CheckComponents;
  ShowComponents(CurPageID);
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  i, ErrCode: Integer;
  CompoFailed: Boolean;
begin
  if CurStep = ssInstall then
  begin
    ISArcExCancel:= 0;
    ISArcExDiskCount:= 0;
    ISArcDiskAddingSuccess:= False;
    ISArcExError:= True;
    CompoFailed:= False;

    ExtractTemporaryFile('english.ini');
    ExtractTemporaryFile('unarc.dll');
    ExtractTemporaryFile('arc.ini');
    ExtractTemporaryFile('cls.ini');
    ExtractTemporaryFile('facompress.dll');
 
		#include "Script_ToolsList_Init.iss"

    repeat

    #if MAX_DISKS > 0
      #sub InitDataFiles
        #define DataSubSec ReadMInI('GetSubSection', '/MainSec=Datas /Idx=' + Str(i) + ' /RootOnly=true')
        #if DataSubSec != ""
          #define DataFile ReadMInI('ReadSubString', '/MainSec=Datas /SubSec=' + DataSubSec + ' /Key=File')
          if FileExists(ExpandConstant('{#DataFile}')) then
          begin
            ISArcDiskAddingSuccess:= ISArcExAddDisks(ExpandConstant('{#DataFile}'), '{#ReadMInI('ReadString', '/Sec=Game /Key=Password')}', ExpandConstant('{app}'));
            if not ISArcDiskAddingSuccess then
              break;
            ISArcExDiskCount := ISArcExDiskCount + 1;
          end;

        #endif
      #endsub
      #for {i = 0; i < MAX_DISKS; i++} InitDataFiles
    #endif

    #if MAX_COMPO > 0
      for i:= 1 to GetArrayLength(CompoData) do
      begin
        if FMXCheckboxTree.CheckboxGetChecked(CompoCheckBox[i]) then
        begin
          ISArcDiskAddingSuccess:= ISArcExAddDisks(CompoData[i].FileName, '{#ReadMInI('ReadString', '/Sec=Game /Key=Password')}', ExpandConstant('{app}'));
          if not ISArcDiskAddingSuccess then
          begin
            CompoFailed:= True;
            break;
          end;
          ISArcExDiskCount:= ISArcExDiskCount + 1;
        end;
      end;

      if CompoFailed then
        break;
    #endif

    until 
      true;

    if ISArcExDiskCount = 0 then
      MsgBox('>>> Error unpacking archives:' + #13 + 'There is no any archive found for unpacking.', mbCriticalError, MB_OK);

    if (ISArcDiskAddingSuccess) and ISArcExInitEx(MainForm.Handle, 3, @ProgressCallbackEx) then
    begin
      repeat
        ISArcExReduceCalcAccuracy(4);
        ISArcExChangeLanguage('english');
        for i:= 1 to ISArcExDiskCount do
        begin
          ISArcExError:= not ISArcExExtract(i, ExpandConstant('{tmp}\arc.ini'), ExpandConstant('{app}'));
          if ISArcExError then
            break;
        end;
      until 
        true;

      ISArcExStop;

      if ISArcExError then
        MsgBox('>>> Error unpacking archives:' + #13 + 'Installation is corrupted, or user cancelled it.', mbError, MB_OK);
    end;

  end;
  if (CurStep = ssPostInstall) and ISArcExError then
    Exec2(ExpandConstant('{uninstallexe}'), '/VERYSILENT', False)
  else
  if (CurStep = ssPostInstall) and (not ISArcExError) then
  begin

  #if MAX_REDIST > 0
    for i:= 1 to GetArrayLength(RedistData) do
    begin
      if FMXCheckboxTree.CheckboxGetChecked(RedistCheckBox[i]) then
        Exec(RedistData[i].FileName, RedistData[i].Args, '', SW_HIDE, ewWaitUntilTerminated, ErrCode);
    end;
  #endif

    RegWriteDWordValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#StringChange(SetupSetting("AppId"), "{{", "{")}_is1', 'EstimatedSize', ComponentSize * 1024);

  end;
end;

procedure InitializeUninstallProgressForm;
begin
  with UninstallProgressForm do
  begin
    ClientWidth:= ScaleX(400);
    ClientHeight:= ScaleY(150);
    InnerNotebook.Hide;
    OuterNotebook.Hide;
    CancelButton.Hide;
    Bevel.Hide;
    PageNameLabel.Hide;
    Position:= poScreenCenter;
    BorderStyle:= bsNone;
    Color:= $001E1715;
    ProgressBar.Parent:= UninstallProgressForm;
    ProgressBar.Top:= ScaleY(120);
    ProgressBar.Width:= ScaleX(380);
    ProgressBar.Left:= (ClientWidth - ProgressBar.Width) div 2;
    ProgressBar.Height:= ScaleY(12);
  end;

  with TLabel.Create(nil) do
  begin
    Parent:= UninstallProgressForm;
    AutoSize:= True;
    Left:= UninstallProgressForm.PageNameLabel.Left;
    Top:= ScaleY(20);
    Caption:= UninstallProgressForm.PageNameLabel.Caption;
    Font.Size:= 12;
    Font.Name:= 'Segoe UI';
    Font.Style:= [fsBold];
    Font.Color:= $00FFFFFE;
  end;

  with TLabel.Create(nil) do
  begin
    Parent:= UninstallProgressForm;
    WordWrap:= True;
    Left:= UninstallProgressForm.PageDescriptionLabel.Left - ScaleX(2);
    Top:= ScaleY(55);
    Width:= UninstallProgressForm.ProgressBar.Width;
    Height:= UninstallProgressForm.PageDescriptionLabel.Height  + ScaleY(45);
    Caption:= UninstallProgressForm.PageDescriptionLabel.Caption;
    Font.Size:= 10;
    Font.Name:= 'Segoe UI';
    Font.Color:= $00C0C0C0;
  end;
end;

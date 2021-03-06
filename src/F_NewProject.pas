unit F_NewProject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormNewProject = class(TForm)
    btnCreateNew: TButton;
    btnCancel: TButton;
    grpBasics: TGroupBox;
    lblProjectFile: TLabel;
    cbbProjectFile: TComboBox;
    btnBrowseProjectFile: TButton;
    lblProjectFileMessage: TLabel;
    lblMapFile: TLabel;
    lblMapFileMessage: TLabel;
    btnBrowseMapFile: TButton;
    edtMapFile: TEdit;
    lblBinary: TLabel;
    edtBinaryFile: TEdit;
    lblBinaryMessage: TLabel;
    btnBrowseBinaryFile: TButton;
    grpProjectOptions: TGroupBox;
    lblParams: TLabel;
    cbbParams: TComboBox;
    lblHost: TLabel;
    cbbHost: TComboBox;
    lblStartDir: TLabel;
    edtStartDir: TEdit;
    Button2: TButton;
    lblHostMessage: TLabel;
    dlgFindFile: TOpenDialog;
    btnExportZombie: TButton;
    dlgExportZombie: TSaveDialog;
    procedure cbbProjectFileChange(Sender: TObject);
    procedure cbbHostChange(Sender: TObject);
    procedure edtMapFileChange(Sender: TObject);
    procedure edtBinaryFileChange(Sender: TObject);
    procedure btnBrowseProjectFileClick(Sender: TObject);
    procedure btnBrowseMapFileClick(Sender: TObject);
    procedure btnBrowseBinaryFileClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCreateNewClick(Sender: TObject);
    procedure btnExportZombieClick(Sender: TObject);
  private
    procedure ValidateInformation;
  public
  end;

var
  FormNewProject: TFormNewProject;

implementation

uses
  StrUtils, IniFiles;

{$R *.dfm}

procedure TFormNewProject.cbbProjectFileChange(Sender: TObject);
begin
  If not FileExists(cbbProjectFile.Text) then
    begin
      lblProjectFileMessage.Font.Color := clRed;
      lblProjectFileMessage.Caption := 'File does not exist';
      lblProjectFileMessage.Visible := true;
    end
  else
    begin
      lblProjectFileMessage.Visible := false;
      
      if FileExists(ChangeFileExt(cbbProjectFile.Text, '.map')) then
        edtMapFile.Text := ChangeFileExt(cbbProjectFile.Text, '.map');

      if AnsiContainsText(cbbProjectFile.Text, '.dpk') and
         FileExists(ChangeFileExt(cbbProjectFile.Text, '.bpl')) then
        edtBinaryFile.Text := ChangeFileExt(cbbProjectFile.Text, '.bpl')
      else
        if FileExists(ChangeFileExt(cbbProjectFile.Text, '.exe')) then
          edtBinaryFile.Text := ChangeFileExt(cbbProjectFile.Text, '.exe')
        else
          if FileExists(ChangeFileExt(cbbProjectFile.Text, '.dll')) then
            edtBinaryFile.Text := ChangeFileExt(cbbProjectFile.Text, '.dll');
    end;

  ValidateInformation();
end;

procedure TFormNewProject.cbbHostChange(Sender: TObject);
begin
  ValidateInformation();

  if Length(cbbHost.Text) > 0 then
    if not FileExists(cbbHost.Text) then
      begin
        lblHostMessage.Font.Color := clRed;
        lblHostMessage.Caption := 'File not found';
        lblHostMessage.Visible := True;
      end
    else
      lblHostMessage.Visible := False;
end;

procedure TFormNewProject.edtMapFileChange(Sender: TObject);
begin
  if not FileExists(edtMapFile.Text) then
    begin
      lblMapFileMessage.Font.Color := clRed;
      lblMapFileMessage.Caption := 'File not found';
      lblMapFileMessage.Visible := True;
    end
  else
    begin
      lblMapFileMessage.Visible := False;

      if FileExists(ChangeFileExt(edtMapFile.Text, '.exe')) then
        edtBinaryFile.Text := ChangeFileExt(edtMapFile.Text, '.exe')
      else
        if FileExists(ChangeFileExt(edtMapFile.Text, '.dll')) then
          edtBinaryFile.Text := ChangeFileExt(edtMapFile.Text, '.dll')
        else
          if FileExists(ChangeFileExt(edtMapFile.Text, '.bpl')) then
            edtBinaryFile.Text := ChangeFileExt(edtMapFile.Text, '.bpl');
    end;

  ValidateInformation();
end;

procedure TFormNewProject.edtBinaryFileChange(Sender: TObject);
begin
  if not FileExists(edtBinaryFile.Text) then
    begin
      lblBinaryMessage.Font.Color := clRed;
      lblBinaryMessage.Caption := 'File not found';
      lblBinaryMessage.Visible := True;
    end
  else
    lblBinaryMessage.Visible := False;

  ValidateInformation();
end;

procedure TFormNewProject.btnBrowseProjectFileClick(Sender: TObject);
begin
  dlgFindFile.Title := 'Find project file';
  dlgFindFile.Filter := 'Delphi project|*.dpr|Delphi package|*.dpk';

  if dlgFindFile.Execute then
    begin
      cbbProjectFile.Text := dlgFindFile.FileName;
      cbbProjectFile.SetFocus();
      cbbProjectFile.OnChange(nil);
    end;
end;

procedure TFormNewProject.btnBrowseMapFileClick(Sender: TObject);
begin
  dlgFindFile.Title := 'Find map file';
  dlgFindFile.Filter := 'Detailed map file|*.map';

  if dlgFindFile.Execute then
    begin
      edtMapFile.Text := dlgFindFile.FileName;
      edtMapFile.SetFocus();
      edtMapFile.OnChange(nil);
    end;
end;

procedure TFormNewProject.btnBrowseBinaryFileClick(Sender: TObject);
begin
  dlgFindFile.Title := 'Find binary file';
  dlgFindFile.Filter := 'Executable|*.exe|Dynamic link library|*.dll|Delphi package|*.bpl';

  if dlgFindFile.Execute then
    begin
      edtBinaryFile.Text := dlgFindFile.FileName;
      edtBinaryFile.SetFocus();
    end;
end;

procedure TFormNewProject.Button2Click(Sender: TObject);
begin
  dlgFindFile.Title := 'Find host application';
  dlgFindFile.Filter := 'Executable|*.exe|Unknown PE format|*.*';

  if dlgFindFile.Execute then
    begin
      cbbHost.Text := dlgFindFile.FileName;
      cbbHost.SetFocus();
    end;
end;

procedure TFormNewProject.ValidateInformation;
begin
  if (AnsiContainsText(cbbProjectFile.Text, '.dpk') or AnsiContainsText(edtBinaryFile.Text, '.dll')) and (Length(cbbHost.Text) = 0) then
    begin
      lblHostMessage.Caption := 'This is necessary for BPL/DLL';
      lblHostMessage.Font.Color := clBlue;
      lblHostMessage.Show();
    end
  else
    lblHostMessage.Hide();

  btnCreateNew.Enabled := FileExists(cbbProjectFile.Text) and FileExists(edtMapFile.Text) and FileExists(edtBinaryFile.Text);
end;

procedure TFormNewProject.FormShow(Sender: TObject);
begin
  edtMapFile.Clear();
  edtBinaryFile.Clear();
  edtStartDir.Clear();
  cbbProjectFile.Clear();
  cbbHost.Clear();
  cbbParams.Clear();


  if FileExists(ExtractFilePath(ParamStr(0)) + '\' + 'ProjectCache.cfg') then
    cbbProjectFile.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) + '\' + 'ProjectCache.cfg');

  if FileExists(ExtractFilePath(ParamStr(0)) + '\' + 'ParamCache.cfg') then
    cbbParams.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) + '\' + 'ParamCache.cfg');

  if FileExists(ExtractFilePath(ParamStr(0)) + '\' + 'HostCache.cfg') then
    cbbHost.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) + '\' + 'HostCache.cfg');

  btnBrowseProjectFile.SetFocus();
end;

procedure TFormNewProject.btnCreateNewClick(Sender: TObject);
begin
  if (cbbProjectFile.Items.IndexOf(cbbProjectFile.Text) = -1) and (Length(cbbProjectFile.Text) > 0) then
    begin
      cbbProjectFile.Items.Add(cbbProjectFile.Text);

      if cbbProjectFile.Items.Count > 20 then
        cbbProjectFile.Items.Delete(0);
    end;

  if (cbbParams.Items.IndexOf(cbbParams.Text) = -1) and (Length(cbbParams.Text) > 0) then
    begin
      cbbParams.Items.Add(cbbParams.Text);

      if cbbParams.Items.Count > 20 then
        cbbParams.Items.Delete(0);
    end;

  if (cbbHost.Items.IndexOf(cbbHost.Text) = -1) and (Length(cbbHost.Text) > 0) then
    begin
      cbbHost.Items.Add(cbbHost.Text);

      if cbbHost.Items.Count > 20 then
        cbbHost.Items.Delete(0);
    end;

  cbbProjectFile.Items.SaveToFile(ExtractFilePath(ParamStr(0)) + '\' + 'ProjectCache.cfg');
  cbbParams.Items.SaveToFile(ExtractFilePath(ParamStr(0)) + '\' + 'ParamCache.cfg');
  cbbHost.Items.SaveToFile(ExtractFilePath(ParamStr(0)) + '\' + 'HostCache.cfg');
end;

procedure TFormNewProject.btnExportZombieClick(Sender: TObject);
var
  lZombieFile : TIniFile;
begin
  dlgExportZombie.FileName := ChangeFileExt(ExtractFileName(cbbProjectFile.Text), '.zp');

  if dlgExportZombie.Execute then
    begin
    lZombieFile := TIniFile.Create(dlgExportZombie.FileName);
    try
      lZombieFile.WriteString('project', 'map', edtMapFile.Text);
      lZombieFile.WriteString('project', 'binary', edtBinaryFile.Text);
      lZombieFile.WriteString('project', 'file', cbbProjectFile.Text);

      lZombieFile.WriteString('run', 'param', cbbParams.Text);
      lZombieFile.WriteString('run', 'startup_dir', edtStartDir.Text);
      lZombieFile.WriteString('run', 'host', cbbHost.Text);
    finally
      lZombieFile.Free();
    end;
  end;
end;

end.

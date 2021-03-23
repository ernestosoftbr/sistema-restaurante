unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons;

type
  TFrmLogin = class(TForm)
    ImgBack: TImage;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    btnEntrar: TSpeedButton;
    procedure FormCreate(Sender: TObject);

    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnEntrarClick(Sender: TObject);
    procedure ChamarLogin;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;


implementation

{$R *.dfm}

uses Principal, modulo;


function ConverterRGB(r, g, b : Byte) : TColor;
begin
    Result := RGB(r, g, b);
end;



procedure TFrmLogin.ChamarLogin;
begin
     if (Trim(edtUsuario.Text) <> '') and (Trim(edtSenha.Text) <> '') then
      begin
             {AQUI ENTRA O LOGIN}

             {VERIFICAR SE O USUARIO e A SENHA EXISTEM NO BANCO}
              DataModule1.queryFunc.sql.Clear;
              DataModule1.queryFunc.sql.Add('select * from funcionarios where usuario = :usuario and senha = :senha');
              DataModule1.queryFunc.ParamByName('usuario').Value := edtUsuario.Text;
              DataModule1.queryFunc.ParamByName('senha').Value := edtSenha.Text;
              DataModule1.queryFunc.Open;



              if not DataModule1.queryFunc.IsEmpty then
              begin
                  {RECUPERAR DADOS DO USUÁRIO LOGADO}
              nomeUsuario := FrmLogin.edtUsuario.Text;
              nomeFuncionario := DataModule1.queryFunc['nome'];
              cargoFuncionario := DataModule1.queryFunc['cargo'];

             FrmPrincipal := TFrmPrincipal.Create(FrmLogin);
             FrmPrincipal.ShowModal;

             end
             else
             begin
               MessageDlg('Dados Incorretos', mtInformation, mbOKCancel, 0);
               edtUsuario.SetFocus;
              end;



      end
      else
      begin
         MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
      end;
end;


procedure TFrmLogin.btnEntrarClick(Sender: TObject);
begin
ChamarLogin();

end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
        {COR HEXADECIMAL}
       { FrmLogin.Color := $FFd9CD;   }

        {COR RBG}
         FrmLogin.Color := ConverterRGB(162, 249, 147);

end;



procedure TFrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if key = 13 then
         ChamarLogin()
end;

end.

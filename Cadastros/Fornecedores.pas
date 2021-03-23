unit Fornecedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Mask, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrmFornecedores = class(TForm)
    ImgBack: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    rbNome: TRadioButton;
    EdtBuscarNome: TEdit;
    EdtNome: TEdit;
    EdtEndereco: TEdit;
    grid: TDBGrid;
    edtCodigo: TEdit;
    EdtTel: TMaskEdit;
    Label3: TLabel;
    EdtEmail: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure EdtBuscarNomeChange(Sender: TObject);
  private
    { Private declarations }

     procedure associarCampos;
    procedure buscarTudo;
    procedure buscarNome;
  public
    { Public declarations }
  end;

var
  FrmFornecedores: TFrmFornecedores;

implementation

{$R *.dfm}

uses modulo;

{ TFrmFornecedores }


procedure LimparCampos();
begin
    With FrmFornecedores do

    begin
    EdtNome.Text := '';
     EdtEmail.Text := '';
    EdtTel.Text := '';
    EdtEndereco.Text := '';

    end
end;


procedure HabilitarCampos();
begin
    With FrmFornecedores do

    begin
    EdtNome.Enabled := True;
     EdtEmail.Enabled := True;
    EdtTel.Enabled := True;
    EdtEndereco.Enabled := True;

    end
end;


procedure DesabilitarCampos();
begin
    With FrmFornecedores do

    begin
     EdtNome.Enabled := False;
     EdtEmail.Enabled := False;
    EdtTel.Enabled := False;
    EdtEndereco.Enabled := False;
    end
end;





procedure TFrmFornecedores.associarCampos;
begin
      DataModule1.tb_fornecedores.FieldByName('nome').Value := edtNome.text;
      DataModule1.tb_fornecedores.FieldByName('telefone').Value := edtTel.Text;
       DataModule1.tb_fornecedores.FieldByName('email').Value := edtEmail.Text;
      DataModule1.tb_fornecedores.FieldByName('endereco').Value := EdtEndereco.text;


end;

procedure TFrmFornecedores.btnDeletarClick(Sender: TObject);
begin
 if MessageDlg('Deseja Excluir o Registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then

        begin
             if edtCodigo.Text <> '' then

                begin
               {DELETANDO OS DADOS}
                DataModule1.tb_fornecedores.Delete;
                MessageDlg('Excluído com Sucesso', mtInformation, mbOKCancel, 0);
                buscarTudo;
                DesabilitarCampos();
                btnEditar.Enabled := False;
                btnDeletar.Enabled := False;
                end
                else
                begin
                   MessageDlg('Selecione um Registro para Exclusão', mtInformation, mbOKCancel, 0);
                   edtNome.SetFocus;
                 end;



        end;
end;

procedure TFrmFornecedores.btnEditarClick(Sender: TObject);
begin
DataModule1.tb_fornecedores.Edit;
     if (edtNome.Text <> '')  then

         begin
             {EDITANDO OS DADOS}
              associarCampos;



              DataModule1.queryConForn.Close;
              DataModule1.queryConForn.SQL.Clear;
              DataModule1.queryConForn.SQL.Add('update fornecedores set nome = :nome, telefone = :telefone, email = :email, endereco = :endereco where id = :id');
              DataModule1.queryConForn.ParamByName('nome').Value := edtNome.Text;

              DataModule1.queryConForn.ParamByName('telefone').Value := edtTel.Text;
              DataModule1.queryConForn.ParamByName('email').Value := edtEmail.Text;
              DataModule1.queryConForn.ParamByName('endereco').Value := edtEndereco.Text;

              DataModule1.queryConForn.ParamByName('id').Value := edtCodigo.Text;
              DataModule1.queryConForn.ExecSQL;



              MessageDlg('Alterado com Sucesso', mtInformation, mbOKCancel, 0);
              buscarTudo;
              DesabilitarCampos();
              btnEditar.Enabled := False;
              btnDeletar.Enabled := False;
        end
        else
        begin
           MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
           edtNome.SetFocus;
        end;

end;

procedure TFrmFornecedores.btnNovoClick(Sender: TObject);
begin
HabilitarCampos();
LimparCampos();
btnSalvar.Enabled := True;
edtNome.SetFocus;

DataModule1.tb_fornecedores.Insert;


BtnNovo.Enabled := False;
grid.Enabled := False;
end;

procedure TFrmFornecedores.btnSalvarClick(Sender: TObject);
begin
 if (edtNome.Text <> '') then

         begin
             {SALVANDO OS DADOS}
             associarCampos;


              DataModule1.tb_fornecedores.Post;
              MessageDlg('Salvo com Sucesso', mtInformation, mbOKCancel, 0);
              buscarTudo;
              DesabilitarCampos();


              btnSalvar.Enabled := False;
              btnNovo.Enabled := True;
              grid.Enabled := True;


        end
        else
        begin
           MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
           edtNome.SetFocus;
        end;
end;

procedure TFrmFornecedores.buscarNome;
begin
 DataModule1.queryConForn.Close;
  DataModule1.queryConForn.SQL.Clear;
  DataModule1.queryConForn.SQL.Add('select * from fornecedores where nome LIKE :nome order by nome asc') ;
  DataModule1.queryConForn.ParamByName('nome').Value := EdtBuscarNome.Text + '%';
  DataModule1.queryConForn.Open;
end;

procedure TFrmFornecedores.buscarTudo;
begin
DataModule1.queryConForn.Close;
  DataModule1.queryConForn.SQL.Clear;
  DataModule1.queryConForn.SQL.Add('select * from fornecedores order by id desc') ;
  DataModule1.queryConForn.Open;
end;

procedure TFrmFornecedores.EdtBuscarNomeChange(Sender: TObject);
begin
if edtBuscarNome.Text <> '' then
begin
   buscarNome;
   end
   else
   begin
     buscarTudo

end;
end;

procedure TFrmFornecedores.FormShow(Sender: TObject);
begin
DataModule1.tb_fornecedores.Active := False;
DataModule1.tb_fornecedores.Active := True;
buscarTudo;
end;

procedure TFrmFornecedores.gridCellClick(Column: TColumn);
begin
HabilitarCampos();
btnEditar.Enabled := True;
btnDeletar.Enabled := True;

DataModule1.tb_fornecedores.Edit;


if DataModule1.queryConForn.FieldByName('telefone').Value <> null then
EdtTel.Text := DataModule1.queryConForn.FieldByName('telefone').Value ;

if DataModule1.queryConForn.FieldByName('nome').Value <> null then
EdtNome.Text := DataModule1.queryConForn.FieldByName('nome').Value ;

if DataModule1.queryConForn.FieldByName('endereco').Value <> null then
EdtEndereco.Text := DataModule1.queryConForn.FieldByName('endereco').Value ;

if DataModule1.queryConForn.FieldByName('email').Value <> null then
EdtEmail.Text := DataModule1.queryConForn.FieldByName('email').Value ;


EdtCodigo.Text := DataModule1.queryConForn.FieldByName('id').Value ;



end;

end.

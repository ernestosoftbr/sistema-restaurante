unit Funcionarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Data.DB, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.Mask,
  System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.EngExt,
  Vcl.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TFrmFuncionarios = class(TForm)
    ImgBack: TImage;
    Label1: TLabel;
    rbNome: TRadioButton;
    rbCPF: TRadioButton;
    EdtBuscarNome: TEdit;
    Label2: TLabel;
    EdtNome: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EdtEndereco: TEdit;
    Label6: TLabel;
    cbCargo: TComboBox;
    grid: TDBGrid;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    EdtBuscarCPF: TMaskEdit;
    edtCodigo: TEdit;
    Label7: TLabel;
    EdtUsuario: TEdit;
    Label8: TLabel;
    EdtSenha: TEdit;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField7: TLinkControlToField;
    EdtCPF: TMaskEdit;
    EdtTel: TMaskEdit;
    Label9: TLabel;
    EdtSenhaConf: TEdit;
    procedure rbCPFClick(Sender: TObject);
    procedure rbNomeClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbCargoChange(Sender: TObject);
    procedure EdtBuscarNomeChange(Sender: TObject);
    procedure EdtBuscarCPFChange(Sender: TObject);
  private
    { Private declarations }

    procedure carregarCombobox;
    procedure associarCampos;
    procedure buscarTudo;
    procedure buscarNome;
     procedure buscarCpf;

  public
    { Public declarations }
  end;

var
  FrmFuncionarios: TFrmFuncionarios;
  usu : String;
  cpf : String;
  cpfAntigo: String;
  usuarioAntigo: String;
implementation

{$R *.dfm}

uses modulo;




procedure LimparCampos();
begin
    With FrmFuncionarios do

    begin
    EdtNome.Text := '';
    EdtCPF.Text := '';
    EdtTel.Text := '';
    EdtEndereco.Text := '';
    EdtUsuario.Text := '';
    EdtSenha.Text := '';
    EdtSenhaConf.Text := '';
    cbCargo.Text := '';
    end
end;


procedure HabilitarCampos();
begin
    With FrmFuncionarios do

    begin
    EdtNome.Enabled := True;
    EdtCPF.Enabled := True;
    EdtTel.Enabled := True;
    EdtEndereco.Enabled := True;
    cbCargo.Enabled := True;
     EdtUsuario.Enabled := True;
    edtSenha.Enabled := True;
    edtSenhaConf.Enabled := True;
    end
end;


procedure DesabilitarCampos();
begin
    With FrmFuncionarios do

    begin
    LimparCampos;
    EdtNome.Enabled := False;
    EdtCPF.Enabled := False;
    EdtTel.Enabled := False;
    EdtEndereco.Enabled := False;
    cbCargo.Enabled := False;
    EdtUsuario.Enabled := False;
    edtSenha.Enabled := False;
    edtSenhaConf.Enabled := False;
    end
end;

procedure TFrmFuncionarios.associarCampos;
begin


      DataModule1.tb_funcionarios.FieldByName('telefone').Value := edtTel.Text;
      DataModule1.tb_funcionarios.FieldByName('cpf').Value := edtCPF.text;
      DataModule1.tb_funcionarios.FieldByName('senha').Value := edtSenha.text;
      DataModule1.tb_funcionarios.FieldByName('nome').Value := edtNome.text;
      DataModule1.tb_funcionarios.FieldByName('endereco').Value := EdtEndereco.text;
      DataModule1.tb_funcionarios.FieldByName('usuario').Value := EdtUsuario.text;

end;

procedure TFrmFuncionarios.btnDeletarClick(Sender: TObject);
begin

        if MessageDlg('Deseja Excluir o Registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then

        begin
             if edtCodigo.Text <> '' then

                begin
               {DELETANDO OS DADOS}
                DataModule1.tb_funcionarios.Delete;
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

procedure TFrmFuncionarios.btnEditarClick(Sender: TObject);
begin


     DataModule1.tb_funcionarios.Edit;
     if (edtNome.Text <> '') and (edtCPF.Text <> '   .   .   -  ') then

         begin
             {EDITANDO OS DADOS}
              associarCampos;

              {VERIFICAR SE AS SENHAS COINCIDEM}
             if edtSenha.Text <> '' then
             begin
               if edtSenha.Text <> edtSenhaConf.Text then
               begin
                  MessageDlg('As senhas não coincidem', mtInformation, mbOKCancel, 0);
                  edtSenhaCOnf.Text := '';
                  edtSenhaCOnf.SetFocus;
                  exit;

               end;

             end;


             {VERIFICAR SE O CPF JÁ ESTÁ CADASTRADO}

             if cpfAntigo <> edtCpf.Text then
             begin
                DataModule1.queryFunc.sql.Clear;
              DataModule1.queryFunc.sql.Add('select cpf from funcionarios where cpf = ' +QuotedStr(Trim(EdtCpf.Text)));
              DataModule1.queryFunc.Open;



              if not DataModule1.queryFunc.IsEmpty then
              begin
               cpf := DataModule1.queryFunc['cpf'];
               MessageDlg('O Cpf ' + cpf + ' já existe no banco de dados!', mtInformation, [mbOk], 0);
               edtCPf.SetFocus;
               Exit;
              end;
             end;







                {VERIFICAR SE O USUARIO JÁ ESTÁ CADASTRADO}
                if usuarioAntigo <> EdtUsuario.Text then
                begin
                    DataModule1.queryFunc.sql.Clear;
              DataModule1.queryFunc.sql.Add('select usuario from funcionarios where usuario = ' +QuotedStr(Trim(EdtUsuario.Text)));
              DataModule1.queryFunc.Open;



              if not DataModule1.queryFunc.IsEmpty then
              begin
              usu := DataModule1.queryFunc['usuario'];
               MessageDlg('O Usuário ' + usu + ' já existe no banco de dados!', mtInformation, [mbOk], 0);
               edtUsuario.SetFocus;
               Exit;
              end;
                end;


              DataModule1.queryConFunc.Close;
              DataModule1.queryConFunc.SQL.Clear;
              DataModule1.queryConFunc.SQL.Add('update funcionarios set nome = :nome, cpf = :cpf, telefone = :telefone, endereco = :endereco, cargo = :cargo, usuario = :usuario, senha = :senha where id = :id');
              DataModule1.queryConFunc.ParamByName('nome').Value := edtNome.Text;
              DataModule1.queryConFunc.ParamByName('cpf').Value := edtCpf.Text;
              DataModule1.queryConFunc.ParamByName('telefone').Value := edtTel.Text;
              DataModule1.queryConFunc.ParamByName('endereco').Value := edtEndereco.Text;
              DataModule1.queryConFunc.ParamByName('cargo').Value := cbCargo.Text;
              DataModule1.queryConFunc.ParamByName('usuario').Value := edtUsuario.Text;
              DataModule1.queryConFunc.ParamByName('senha').Value := edtSenha.Text;
              DataModule1.queryConFunc.ParamByName('id').Value := edtCodigo.Text;
              DataModule1.queryConFunc.ExecSQL;



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

procedure TFrmFuncionarios.btnNovoClick(Sender: TObject);
begin

HabilitarCampos();
LimparCampos();
btnSalvar.Enabled := True;
edtNome.SetFocus;

DataModule1.tb_funcionarios.Insert;
DataModule1.tb_funcionarios.FieldByName('data').Value := DateToStr(Date);

BtnNovo.Enabled := False;
grid.Enabled := False;
end;

procedure TFrmFuncionarios.btnSalvarClick(Sender: TObject);
begin
       if (edtNome.Text <> '') and (edtCPF.Text <> '   .   .   -  ') then

         begin
             {SALVANDO OS DADOS}
             associarCampos;

             {VERIFICAR SE AS SENHAS COINCIDEM}
             if edtSenha.Text <> '' then
             begin
               if edtSenha.Text <> edtSenhaConf.Text then
               begin
                  MessageDlg('As senhas não coincidem', mtInformation, mbOKCancel, 0);
                  edtSenhaCOnf.Text := '';
                  edtSenhaCOnf.SetFocus;
                  exit;

               end;

             end;


             {VERIFICAR SE O CPF JÁ ESTÁ CADASTRADO}

              DataModule1.queryFunc.sql.Clear;
              DataModule1.queryFunc.sql.Add('select cpf from funcionarios where cpf = ' +QuotedStr(Trim(EdtCpf.Text)));
              DataModule1.queryFunc.Open;



              if not DataModule1.queryFunc.IsEmpty then
              begin
               cpf := DataModule1.queryFunc['cpf'];
               MessageDlg('O Cpf ' + cpf + ' já existe no banco de dados!', mtInformation, [mbOk], 0);
               edtCPf.SetFocus;
               Exit;
              end;




                {VERIFICAR SE O USUARIO JÁ ESTÁ CADASTRADO}
                DataModule1.queryFunc.sql.Clear;
              DataModule1.queryFunc.sql.Add('select usuario from funcionarios where usuario = ' +QuotedStr(Trim(EdtUsuario.Text)));
              DataModule1.queryFunc.Open;



              if not DataModule1.queryFunc.IsEmpty then
              begin
              usu := DataModule1.queryFunc['usuario'];
               MessageDlg('O Usuário ' + usu + ' já existe no banco de dados!', mtInformation, [mbOk], 0);
               edtUsuario.SetFocus;
               Exit;
              end;

              DataModule1.tb_funcionarios.Post;
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




procedure TFrmFuncionarios.buscarCpf;
begin
    DataModule1.queryConFunc.Close;
  DataModule1.queryConFunc.SQL.Clear;
  DataModule1.queryConFunc.SQL.Add('select * from funcionarios where cpf = :cpf order by nome asc') ;
  DataModule1.queryConFunc.ParamByName('cpf').Value := EdtBuscarCpf.Text;
  DataModule1.queryConFunc.Open;
end;

procedure TFrmFuncionarios.buscarNome;
begin
    DataModule1.queryConFunc.Close;
  DataModule1.queryConFunc.SQL.Clear;
  DataModule1.queryConFunc.SQL.Add('select * from funcionarios where nome LIKE :nome order by nome asc') ;
  DataModule1.queryConFunc.ParamByName('nome').Value := EdtBuscarNome.Text + '%';
  DataModule1.queryConFunc.Open;
end;

procedure TFrmFuncionarios.buscarTudo;
begin
  DataModule1.queryConFunc.Close;
  DataModule1.queryConFunc.SQL.Clear;
  DataModule1.queryConFunc.SQL.Add('select * from funcionarios order by id desc') ;
  DataModule1.queryConFunc.Open;

end;

procedure TFrmFuncionarios.carregarCombobox;
begin



    With DataModule1.tb_cargo do
    begin


      Active := False;
      Active := True;

      if not isEmpty then
      begin
          while not Eof do
          begin
            cbCargo.Items.Add(FieldByName('nome').AsString);
            Next;

          end;


      end;

    end;
end;

procedure TFrmFuncionarios.cbCargoChange(Sender: TObject);
begin
DataModule1.tb_funcionarios.FieldByName('cargo').Value := cbcargo.Text;
end;

procedure TFrmFuncionarios.EdtBuscarCPFChange(Sender: TObject);
begin
if edtBuscarCpf.Text <> '' then
begin
   buscarCpf;
   end
   else
   begin
     buscarTudo

end;
end;

procedure TFrmFuncionarios.EdtBuscarNomeChange(Sender: TObject);
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

procedure TFrmFuncionarios.FormShow(Sender: TObject);
begin
buscarTudo;
DataModule1.tb_funcionarios.Active := False;
DataModule1.tb_funcionarios.Active := True;
carregarCombobox;
end;

procedure TFrmFuncionarios.gridCellClick(Column: TColumn);
begin
HabilitarCampos();
btnEditar.Enabled := True;
btnDeletar.Enabled := True;

DataModule1.tb_funcionarios.Edit;

if DataModule1.queryConFunc.FieldByName('cargo').Value <> null then
cbCargo.Text := DataModule1.queryConFunc.FieldByName('cargo').Value;

if DataModule1.queryConFunc.FieldByName('cpf').Value <> null then
EdtCPF.Text := DataModule1.queryConFunc.FieldByName('cpf').Value;

if DataModule1.queryConFunc.FieldByName('telefone').Value <> null then
EdtTel.Text := DataModule1.queryConFunc.FieldByName('telefone').Value ;

if DataModule1.queryConFunc.FieldByName('senha').Value <> null then
EdtSenhaConf.Text := DataModule1.queryConFunc.FieldByName('senha').Value ;

if DataModule1.queryConFunc.FieldByName('senha').Value <> null then
EdtSenha.Text := DataModule1.queryConFunc.FieldByName('senha').Value ;

if DataModule1.queryConFunc.FieldByName('usuario').Value <> null then
EdtUsuario.Text := DataModule1.queryConFunc.FieldByName('usuario').Value ;

if DataModule1.queryConFunc.FieldByName('nome').Value <> null then
EdtNome.Text := DataModule1.queryConFunc.FieldByName('nome').Value ;

if DataModule1.queryConFunc.FieldByName('endereco').Value <> null then
EdtEndereco.Text := DataModule1.queryConFunc.FieldByName('endereco').Value ;


EdtCodigo.Text := DataModule1.queryConFunc.FieldByName('id').Value ;




cpfAntigo := DataModule1.queryConFunc.FieldByName('cpf').Value;
usuarioAntigo := DataModule1.queryConFunc.FieldByName('usuario').Value;

end;

procedure TFrmFuncionarios.rbCPFClick(Sender: TObject);
begin
if rbCPF.Checked = True then
    EdtBuscarNome.Text := '';
     EdtBuscarNome.Visible := False;
      EdtBuscarCPF.Text := '';
     EdtBuscarCPF.Visible := True;
end;

procedure TFrmFuncionarios.rbNomeClick(Sender: TObject);
begin
      if rbCPF.Checked = True then
    EdtBuscarNome.Text := '';
     EdtBuscarNome.Visible := True;
      EdtBuscarCPF.Text := '';
     EdtBuscarCPF.Visible := False;
end;

end.

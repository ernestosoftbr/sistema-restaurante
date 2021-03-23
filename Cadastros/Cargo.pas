unit Cargo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.EngExt,
  Vcl.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TFrmCargo = class(TForm)
    ImgBack: TImage;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    grid: TDBGrid;
    Label2: TLabel;
    EdtNome: TEdit;
    edtCodigo: TEdit;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    procedure btnDeletarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCargo: TFrmCargo;

implementation

{$R *.dfm}

uses modulo;

procedure TFrmCargo.btnDeletarClick(Sender: TObject);
begin
if MessageDlg('Deseja Excluir o Registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then

        begin
             if edtCodigo.Text <> '' then

                begin
               {SALVANDO OS DADOS}
                DataModule1.tb_cargo.Delete;
                MessageDlg('Excluído com Sucesso', mtInformation, mbOKCancel, 0);
                EdtNome.Enabled := False;
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

procedure TFrmCargo.btnEditarClick(Sender: TObject);
begin
if (edtNome.Text <> '') then

         begin
             {SALVANDO OS DADOS}
              DataModule1.tb_cargo.Edit;
              MessageDlg('Alterado com Sucesso', mtInformation, mbOKCancel, 0);

              EdtNome.Enabled := False;
              btnEditar.Enabled := False;
              btnDeletar.Enabled := False;
        end
        else
        begin
           MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
           edtNome.SetFocus;
        end;
end;

procedure TFrmCargo.btnNovoClick(Sender: TObject);
begin

EdtNome.Enabled := True;
EdtNome.Text := '';
btnSalvar.Enabled := True;
edtNome.SetFocus;
DataModule1.tb_cargo.Insert;

end;

procedure TFrmCargo.btnSalvarClick(Sender: TObject);
begin
if (edtNome.Text <> '')  then

         begin
             {SALVANDO OS DADOS}


              DataModule1.tb_cargo.Post;
              MessageDlg('Salvo com Sucesso', mtInformation, mbOKCancel, 0);

              EdtNome.Enabled := False;
              btnSalvar.Enabled := False;
        end
        else
        begin
           MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
           edtNome.SetFocus;
        end;


end;

procedure TFrmCargo.gridCellClick(Column: TColumn);
begin
edtNome.Enabled := True;
btnEditar.Enabled := True;
btnDeletar.Enabled := True;
end;

end.

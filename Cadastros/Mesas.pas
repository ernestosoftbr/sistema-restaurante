unit Mesas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.EngExt,
  Vcl.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TFrmMesas = class(TForm)
    ImgBack: TImage;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    Label2: TLabel;
    grid: TDBGrid;
    EdtMesa: TEdit;
    edtCodigo: TEdit;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMesas: TFrmMesas;

implementation

{$R *.dfm}

uses modulo;

procedure TFrmMesas.btnDeletarClick(Sender: TObject);
begin
if MessageDlg('Deseja Excluir o Registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then

        begin
             if edtCodigo.Text <> '' then

                begin
               {SALVANDO OS DADOS}
                DataModule1.tb_mesas.Delete;
                MessageDlg('Excluído com Sucesso', mtInformation, mbOKCancel, 0);
                EdtMesa.Enabled := False;
                btnEditar.Enabled := False;
                btnDeletar.Enabled := False;
                end
                else
                begin
                   MessageDlg('Selecione um Registro para Exclusão', mtInformation, mbOKCancel, 0);
                   edtMesa.SetFocus;
                 end;



        end;
end;

procedure TFrmMesas.btnEditarClick(Sender: TObject);
begin
if (edtMesa.Text <> '') then

         begin
             {SALVANDO OS DADOS}
              DataModule1.tb_mesas.Edit;
              MessageDlg('Alterado com Sucesso', mtInformation, mbOKCancel, 0);

              EdtMesa.Enabled := False;
              btnEditar.Enabled := False;
              btnDeletar.Enabled := False;
        end
        else
        begin
           MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
           edtMesa.SetFocus;
        end;
end;

procedure TFrmMesas.btnNovoClick(Sender: TObject);
begin
EdtMesa.Enabled := True;
EdtMesa.Text := '';
btnSalvar.Enabled := True;
EdtMesa.SetFocus;
DataModule1.tb_mesas.Insert;
end;

procedure TFrmMesas.btnSalvarClick(Sender: TObject);
begin
if (edtMesa.Text <> '')  then

         begin
             {SALVANDO OS DADOS}


              DataModule1.tb_mesas.Post;
              MessageDlg('Salvo com Sucesso', mtInformation, mbOKCancel, 0);

              EdtMesa.Enabled := False;
              btnSalvar.Enabled := False;
        end
        else
        begin
           MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
           edtMesa.SetFocus;
        end;
end;

procedure TFrmMesas.gridCellClick(Column: TColumn);
begin
edtMesa.Enabled := True;
btnEditar.Enabled := True;
btnDeletar.Enabled := True;
end;

end.

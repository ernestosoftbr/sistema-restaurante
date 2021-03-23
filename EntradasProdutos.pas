unit EntradasProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrmEntradasProdutos = class(TForm)
    ImgBack: TImage;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    Label2: TLabel;
    EdtNome: TEdit;
    edtCodigo: TEdit;
    Label1: TLabel;
    EdtQuantidade: TEdit;
    BtnIr: TButton;
    procedure btnNovoClick(Sender: TObject);
    procedure BtnIrClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmEntradasProdutos: TFrmEntradasProdutos;

  quant : Real;

implementation

uses
  modulo, Produtos;

{$R *.dfm}

procedure TFrmEntradasProdutos.BtnIrClick(Sender: TObject);
begin
FrmProdutos := TFrmProdutos.Create(self);
FrmProdutos.Show;
end;

procedure TFrmEntradasProdutos.btnNovoClick(Sender: TObject);
begin
EdtQuantidade.Enabled := True;
EdtQuantidade.Text := '';
EdtNome.Text := '';
EdtCodigo.Text := '';
btnSalvar.Enabled := True;
btnIr.Enabled := True;
edtQuantidade.SetFocus;
DataModule1.tb_produtos.Insert;
end;

procedure TFrmEntradasProdutos.btnSalvarClick(Sender: TObject);
begin
if (EdtQuantidade.Text <> '') then

         begin
             {editando quantidade de produtos}

              quant := strtofloat(quantidadeproduto) + strtofloat(EdtQuantidade.Text);

              DataModule1.queryConProd.Close;
              DataModule1.queryConProd.SQL.Clear;

              DataModule1.queryConProd.SQL.Add('update produtos set quantidade = :quantidade where id = :id');

              DataModule1.queryConProd.ParamByName('quantidade').Value := FloatToStr(quant);

              DataModule1.queryConProd.ParamByName('id').Value := edtCodigo.Text;
              DataModule1.queryConProd.ExecSQL;



              MessageDlg('Alterado com Sucesso', mtInformation, mbOKCancel, 0);
              EdtNome.Text := '';
              EdtQuantidade.Text := '';
              EdtCodigo.Text := '';
              btnSalvar.Enabled := false;
              btnNovo.Enabled := True;
              BtnIr.Enabled := False;
        end
        else
        begin
           MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
           edtNome.SetFocus;
        end;
end;

procedure TFrmEntradasProdutos.FormActivate(Sender: TObject);
begin
 EdtNome.Text := nomeProduto;
 edtCodigo.Text := idProduto;
end;

procedure TFrmEntradasProdutos.FormShow(Sender: TObject);
begin
  DataModule1.tb_produtos.Active := False;
  DataModule1.tb_produtos.Active := True;
end;

end.

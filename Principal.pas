unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.Buttons, Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    ImgBack: TImage;
    MainMenu1: TMainMenu;
    Cadastros1: TMenuItem;
    Produtos1: TMenuItem;
    Movimentaes1: TMenuItem;
    Pedidos1: TMenuItem;
    Relatrios1: TMenuItem;
    Sair1: TMenuItem;
    Reservas1: TMenuItem;
    Clientes1: TMenuItem;
    Fornecedores1: TMenuItem;
    Mesas1: TMenuItem;
    CadastrodeProdutos1: TMenuItem;
    EntradasdeProdutos1: TMenuItem;
    NveldoEstoque1: TMenuItem;
    NovaVenda1: TMenuItem;
    EntradaseSadas1: TMenuItem;
    Gastos1: TMenuItem;
    Pagamentos1: TMenuItem;
    eladePedidos1: TMenuItem;
    NovaReserva1: TMenuItem;
    ConsultarReservas1: TMenuItem;
    Logout1: TMenuItem;
    btnProdutos: TSpeedButton;
    btnMovimentacoes: TSpeedButton;
    btnPedidos: TSpeedButton;
    btnReservas: TSpeedButton;
    btnRelatorio: TSpeedButton;
    Pratos1: TMenuItem;
    Cargo1: TMenuItem;
    NovoPedido1: TMenuItem;
    StatusdosPedidos1: TMenuItem;
    lblUsuario: TLabel;
    lblCargo: TLabel;
    RelatriodeProdutos1: TMenuItem;
    lblData: TLabel;
    lblHora: TLabel;
    Timer1: TTimer;
    procedure Clientes1Click(Sender: TObject);
    procedure CadastrodeProdutos1Click(Sender: TObject);
    procedure btnProdutosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cargo1Click(Sender: TObject);
    procedure Fornecedores1Click(Sender: TObject);
    procedure RelatriodeProdutos1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Mesas1Click(Sender: TObject);
    procedure Pratos1Click(Sender: TObject);
    procedure EntradasdeProdutos1Click(Sender: TObject);
    procedure NovaVenda1Click(Sender: TObject);
    procedure EntradaseSadas1Click(Sender: TObject);
    procedure Gastos1Click(Sender: TObject);
    procedure Pagamentos1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses Funcionarios, Produtos, modulo, Login, Cargo, Fornecedores, Mesas, Pratos, EntradasProdutos, Vendas, Movimentacoes, Gastos, Pagamentos;

procedure TFrmPrincipal.btnProdutosClick(Sender: TObject);
begin
  FrmProdutos := TFrmProdutos.Create(self);
FrmProdutos.ShowModal;
end;

procedure TFrmPrincipal.CadastrodeProdutos1Click(Sender: TObject);
begin
  FrmProdutos := TFrmProdutos.Create(self);
FrmProdutos.ShowModal;
end;

procedure TFrmPrincipal.Cargo1Click(Sender: TObject);
begin
FrmCargo := TFrmCargo.Create(self);
FrmCargo.ShowModal;
end;

procedure TFrmPrincipal.Clientes1Click(Sender: TObject);
begin
FrmFuncionarios := TFrmFuncionarios.Create(self);
FrmFuncionarios.ShowModal;
end;

procedure TFrmPrincipal.EntradasdeProdutos1Click(Sender: TObject);
begin
FrmEntradasProdutos := TFrmEntradasProdutos.Create(self);
FrmEntradasProdutos.ShowModal;
end;

procedure TFrmPrincipal.EntradaseSadas1Click(Sender: TObject);
begin
  FrmMovimentacoes := TFrmMovimentacoes.Create(self);
  FrmMovimentacoes.ShowModal;
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
lblUsuario.Caption := nomeFuncionario;
lblCargo.Caption := CargoFuncionario;
lblData.Caption := DateToStr(Date);
lblHora.Caption := TimeToStr(Time);
end;

procedure TFrmPrincipal.Fornecedores1Click(Sender: TObject);
begin

FrmFornecedores := TFrmFornecedores.Create(self);
FrmFornecedores.ShowModal;
end;

procedure TFrmPrincipal.Gastos1Click(Sender: TObject);
begin
  FrmGastos := TFrmGastos.Create(self);
  FrmGastos.ShowModal;
end;

procedure TFrmPrincipal.Logout1Click(Sender: TObject);
begin
FrmLogin := TFrmLogin.Create(self);
Hide();
FrmLogin.ShowModal;

end;

procedure TFrmPrincipal.Mesas1Click(Sender: TObject);
begin
FrmMesas := TFrmMesas.Create(self);
FrmMesas.ShowModal;
end;

procedure TFrmPrincipal.NovaVenda1Click(Sender: TObject);
begin
  FrmVendas := TFrmVendas.Create(self);
  FrmVendas.ShowModal;
end;

procedure TFrmPrincipal.Pagamentos1Click(Sender: TObject);
begin
FrmPagamentos := TFrmPagamentos.Create(self);
FrmPagamentos.ShowModal;
end;

procedure TFrmPrincipal.Pratos1Click(Sender: TObject);
begin
  FrmPratos := TFrmPratos.Create(self);
  FrmPratos.ShowModal;
end;

procedure TFrmPrincipal.RelatriodeProdutos1Click(Sender: TObject);
begin

{passando nova consulta parar o relatorio}
DataModule1.queryConProd.Close;
  DataModule1.queryConProd.SQL.Clear;
  DataModule1.queryConProd.SQL.Add('select p.id, p.nome, p.descricao, p.valor, p.quantidade, p.fornecedor, f.nome, p.imagem from produtos as p INNER JOIN fornecedores as f ON p.fornecedor = f.id order by p.nome asc') ;
  DataModule1.queryConProd.Open;

DataModule1.rel_produtos.LoadFromFile(GetCurrentDir + '\Rel\RelProdutos.fr3');

DataModule1.rel_produtos.ShowReport();
end;

procedure TFrmPrincipal.Timer1Timer(Sender: TObject);
begin
lblHora.Caption := TimeToStr(Time);
lblData.Caption := DateToStr(Date);
end;

end.

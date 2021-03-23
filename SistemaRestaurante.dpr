program SistemaRestaurante;

uses
  Vcl.Forms,
  Login in 'Login.pas' {FrmLogin},
  Principal in 'Principal.pas' {FrmPrincipal},
  Funcionarios in 'Cadastros\Funcionarios.pas' {FrmFuncionarios},
  Produtos in 'Produtos\Produtos.pas' {FrmProdutos},
  Cargo in 'Cadastros\Cargo.pas' {FrmCargo},
  modulo in 'modulo.pas' {DataModule1: TDataModule},
  Fornecedores in 'Cadastros\Fornecedores.pas' {FrmFornecedores},
  Mesas in 'Cadastros\Mesas.pas' {FrmMesas},
  Pratos in 'Cadastros\Pratos.pas' {FrmPratos},
  EntradasProdutos in 'EntradasProdutos.pas' {FrmEntradasProdutos},
  Vendas in 'Movimentacoes\Vendas.pas' {FrmVendas},
  Movimentacoes in 'Movimentacoes\Movimentacoes.pas' {FrmMovimentacoes},
  Gastos in 'Movimentacoes\Gastos.pas' {FrmGastos},
  Pagamentos in 'Movimentacoes\Pagamentos.pas' {FrmPagamentos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmFuncionarios, FrmFuncionarios);
  Application.CreateForm(TFrmProdutos, FrmProdutos);
  Application.CreateForm(TFrmCargo, FrmCargo);
  Application.CreateForm(TFrmFornecedores, FrmFornecedores);
  Application.CreateForm(TFrmMesas, FrmMesas);
  Application.CreateForm(TFrmPratos, FrmPratos);
  Application.CreateForm(TFrmEntradasProdutos, FrmEntradasProdutos);
  Application.Run;
end.

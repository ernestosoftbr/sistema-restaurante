unit modulo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Data.FMTBcd, Data.SqlExpr, frxClass,
  frxDBSet;

type
  TDataModule1 = class(TDataModule)
    FDConnection1: TFDConnection;
    Driver: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    tb_cargo: TFDTable;
    dsCargo: TDataSource;
    tb_cargoid: TFDAutoIncField;
    tb_cargonome: TStringField;
    dsFuncionarios: TDataSource;
    tb_funcionarios: TFDTable;
    tb_funcionariosid: TFDAutoIncField;
    tb_funcionariosnome: TStringField;
    tb_funcionarioscpf: TStringField;
    tb_funcionariostelefone: TStringField;
    tb_funcionariosendereco: TStringField;
    tb_funcionarioscargo: TStringField;
    tb_funcionariosusuario: TStringField;
    tb_funcionariossenha: TStringField;
    tb_funcionariosdata: TDateField;
    queryFunc: TFDQuery;
    queryConFunc: TFDQuery;
    dsConFuncionarios: TDataSource;
    queryConFuncid: TFDAutoIncField;
    queryConFuncnome: TStringField;
    queryConFunccpf: TStringField;
    queryConFunctelefone: TStringField;
    queryConFuncendereco: TStringField;
    queryConFunccargo: TStringField;
    queryConFuncusuario: TStringField;
    queryConFuncsenha: TStringField;
    queryConFuncdata: TDateField;
    tb_fornecedores: TFDTable;
    dsFornecedores: TDataSource;
    tb_fornecedoresid: TFDAutoIncField;
    tb_fornecedoresnome: TStringField;
    tb_fornecedorestelefone: TStringField;
    tb_fornecedoresemail: TStringField;
    tb_fornecedoresendereco: TStringField;
    queryConForn: TFDQuery;
    ConFornecedores: TDataSource;
    queryConFornid: TFDAutoIncField;
    queryConFornnome: TStringField;
    queryConForntelefone: TStringField;
    queryConFornemail: TStringField;
    queryConFornendereco: TStringField;
    tb_produtos: TFDTable;
    tb_produtosid: TFDAutoIncField;
    tb_produtosnome: TStringField;
    tb_produtosdescricao: TStringField;
    tb_produtosvalor: TBCDField;
    tb_produtosquantidade: TIntegerField;
    tb_produtosfornecedor: TIntegerField;
    tb_produtosimagem: TBlobField;
    queryConProd: TFDQuery;
    queryConProdid: TFDAutoIncField;
    queryConProdnome: TStringField;
    queryConProddescricao: TStringField;
    queryConProdvalor: TBCDField;
    queryConProdquantidade: TIntegerField;
    queryConProdfornecedor: TIntegerField;
    queryConProdimagem: TBlobField;
    ConProdutos: TDataSource;
    queryConProdnome_1: TStringField;
    rel_produtos: TfrxReport;
    rel_ds_produtos: TfrxDBDataset;
    tb_mesas: TFDTable;
    dsMesas: TDataSource;
    tb_mesasid: TFDAutoIncField;
    tb_mesasmesa: TStringField;
    tb_pratos: TFDTable;
    tb_pratosid: TFDAutoIncField;
    tb_pratosnome: TStringField;
    tb_pratosvalor: TBCDField;
    dsPratos: TDataSource;
    tb_vendas: TFDTable;
    tb_detalhes_vendas: TFDTable;
    tb_vendasid: TFDAutoIncField;
    tb_vendasValor: TBCDField;
    tb_vendasfuncionario: TStringField;
    tb_vendasdata: TDateField;
    tb_detalhes_vendasid: TFDAutoIncField;
    tb_detalhes_vendasid_venda: TIntegerField;
    tb_detalhes_vendasproduto: TStringField;
    tb_detalhes_vendasvalor: TBCDField;
    tb_detalhes_vendasvalor_total: TBCDField;
    tb_detalhes_vendasquantidade: TIntegerField;
    queryConVendas: TFDQuery;
    conVendas: TDataSource;
    queryConDetalhes: TFDQuery;
    conDetalhes: TDataSource;
    queryConVendasid: TFDAutoIncField;
    queryConVendasValor: TBCDField;
    queryConVendasfuncionario: TStringField;
    queryConVendasdata: TDateField;
    queryConDetalhesid: TFDAutoIncField;
    queryConDetalhesid_venda: TIntegerField;
    queryConDetalhesproduto: TStringField;
    queryConDetalhesvalor: TBCDField;
    queryConDetalhesvalor_total: TBCDField;
    queryConDetalhesquantidade: TIntegerField;
    tb_detalhes_vendasid_produto: TIntegerField;
    rel_Comprovante: TfrxReport;
    rel_ds_comp_detalhes: TfrxDBDataset;
    rel_ds_comp_vendas: TfrxDBDataset;
    tb_movimentacoes: TFDTable;
    tb_movimentacoesid: TFDAutoIncField;
    tb_movimentacoestipo: TStringField;
    tb_movimentacoesmovimento: TStringField;
    tb_movimentacoesvalor: TBCDField;
    tb_movimentacoesfuncionario: TStringField;
    tb_movimentacoesdata: TDateField;
    queryConDetalhesid_produto: TIntegerField;
    queryConMov: TFDQuery;
    ConMov: TDataSource;
    tb_gastos: TFDTable;
    tb_pagamentos: TFDTable;
    ds_gastos: TDataSource;
    tb_gastosid: TFDAutoIncField;
    tb_gastosdescricao: TStringField;
    tb_gastosvalor: TBCDField;
    tb_gastosfuncionario: TStringField;
    tb_gastosData: TDateField;
    tb_pagamentosid: TFDAutoIncField;
    tb_pagamentosfuncionario: TStringField;
    tb_pagamentosvalor: TBCDField;
    tb_pagamentosgerente: TStringField;
    tb_pagamentosdata: TDateField;
    ds_pagamentos: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;
  nomeUsuario: String;
  nomeFuncionario: String;
  cargoFuncionario: String;

  idProduto: string;
  nomeProduto: string;
  quantidadeProduto: string;
  valorProduto: string;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin

  {CONECTANDO AO BANCO DE DADOS LOCAL}

  FDConnection1.Params.Database := 'restaurante';
  FDConnection1.Params.UserName := 'root';
  FDConnection1.Params.Password := 'abc@123';

  Driver.VendorLib := GetCurrentDir + '\lib\libmySQL.dll';

  FDConnection1.Connected := True;


   {INFORMAÇÕES DAS TABELAS - ASSOCIAÇÃO VIA CÓDIGO}
   {tb_cargo.TableName := 'cargo';
   tb_cargo.Active := True;   }


end;

end.

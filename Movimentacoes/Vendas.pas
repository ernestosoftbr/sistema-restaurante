unit Vendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmVendas = class(TForm)
    Label2: TLabel;
    Label5: TLabel;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnDeletar: TSpeedButton;
    Label4: TLabel;
    EdtNome: TEdit;
    EdtValor: TEdit;
    grid: TDBGrid;
    edtCodigo: TEdit;
    EdtQuantidade: TEdit;
    BtnIr: TButton;
    Label1: TLabel;
    lblTotalVenda: TLabel;
    Label3: TLabel;
    edtEstoque: TEdit;
    EdtQuantItem: TEdit;
    edtQuanDetalhes: TEdit;
    ImgBack: TImage;
    EdtCodigoVenda: TEdit;
    gridVendas: TDBGrid;
    Label6: TLabel;
    Data: TDateTimePicker;
    btnAddItem: TSpeedButton;
    btnRelatorio: TSpeedButton;
    procedure btnNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnIrClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure btnAddItemClick(Sender: TObject);
    procedure gridVendasCellClick(Column: TColumn);
    procedure btnRelatorioClick(Sender: TObject);
    procedure DataChange(Sender: TObject);
  private
    { Private declarations }
    procedure associarCampos;
    procedure associarCamposVendas;
    procedure buscarTudo;
    procedure buscarTudoVendas;
    procedure buscarData;
  public
    { Public declarations }
  end;

var
  FrmVendas: TFrmVendas;
  total_venda: real;
  ultimoId: integer;
  quant: real;

implementation

uses
  modulo, Produtos;

{$R *.dfm}

procedure LimparCampos();
begin
  With FrmVendas do
  begin
    EdtNome.Text := '';
    EdtQuantidade.Text := '1';
    EdtValor.Text := '0';
    edtEstoque.Text := '';
  end

end;

procedure TFrmVendas.associarCampos;
begin
  DataModule1.tb_detalhes_vendas.FieldByName('produto').Value := edtNome.text;
  DataModule1.tb_detalhes_vendas.FieldByName('valor').Value := EdtValor.text;
  DataModule1.tb_detalhes_vendas.FieldByName('quantidade').Value := EdtQuantidade.text;
  DataModule1.tb_detalhes_vendas.FieldByName('valor_total').Value := StrToFloat(EdtValor.text) * StrToFloat(EdtQuantidade.text);
  DataModule1.tb_detalhes_vendas.FieldByName('id_venda').Value := '0';

  DataModule1.tb_detalhes_vendas.FieldByName('id_produto').Value := edtcodigo.text;

end;

procedure TFrmVendas.associarCamposVendas;
begin
  DataModule1.tb_vendas.FieldByName('data').Value := DateToStr(Date);
  DataModule1.tb_vendas.FieldByName('valor').Value := lblTotalVenda.Caption;
  DataModule1.tb_vendas.FieldByName('funcionario').Value := nomeFuncionario;

end;

procedure TFrmVendas.btnDeletarClick(Sender: TObject);
begin
  DataModule1.tb_detalhes_vendas.Delete;
  buscarTudo;
  btnDeletar.Enabled := False;

  // DEVOLVENDO QUANTIDADE NO ESTOQUE
        DataModule1.queryConProd.Close;
        DataModule1.queryConProd.SQL.Clear;
        DataModule1.queryConProd.SQL.Add('select p.id, p.nome, p.descricao, p.valor, p.quantidade, p.fornecedor, f.nome, p.imagem from produtos as p INNER JOIN fornecedores as f ON p.fornecedor = f.id where p.id= :id');
        DataModule1.queryConProd.ParamByName('id').Value := edtCodigo.text;
        DataModule1.queryConProd.Open();
        quant := DataModule1.queryConProd['quantidade'];


        quant := quant + StrToFloat(edtQuanDetalhes.Text);
        DataModule1.queryConProd.Close;
        DataModule1.queryConProd.SQL.Clear;
        DataModule1.queryConProd.SQL.Add('update produtos set quantidade = :quantidade where id = :id');
        DataModule1.queryConProd.ParamByName('quantidade').Value := quant;
        DataModule1.queryConProd.ParamByName('id').Value := edtCodigo.text;
        DataModule1.queryConProd.ExecSQL;

  total_venda := total_venda - StrToFloat(edtQuantItem.Text);
  lblTotalVenda.Caption := FormatFloat('R$ #,,,,0.00',total_venda);

end;

procedure TFrmVendas.BtnIrClick(Sender: TObject);
begin
  FrmProdutos := TFrmProdutos.Create(self);
  FrmProdutos.Show;
end;

procedure TFrmVendas.btnNovoClick(Sender: TObject);
begin
  total_venda := 0;
  LimparCampos();
  btnSalvar.Enabled := True;
  btnAddItem.Enabled := True;
  btnir.Enabled := True;
  edtQuantidade.Enabled := true;
  edtQuantidade.SetFocus;


  BtnNovo.Enabled := False;
  gridVendas.Enabled := false;
  grid.Enabled := true;
end;

procedure TFrmVendas.btnRelatorioClick(Sender: TObject);
begin
  //passando nova consulta parar o relatorio de vendas
  DataModule1.queryConVendas.Close;
  DataModule1.queryConVendas.SQL.Clear;
  DataModule1.queryConVendas.SQL.Add('select * from vendas where id = :id') ;
  DataModule1.queryConVendas.ParamByName('id').Value := edtCodigoVenda.Text;
  DataModule1.queryConVendas.Open;

  DataModule1.queryConDetalhes.Close;
  DataModule1.queryConDetalhes.SQL.Clear;
  DataModule1.queryConDetalhes.SQL.Add('select * from detalhes_venda where id_venda = :id') ;
  DataModule1.queryConDetalhes.ParamByName('id').Value := edtCodigoVenda.Text;
  DataModule1.queryConDetalhes.Open;

  DataModule1.rel_Comprovante.LoadFromFile(GetCurrentDir + '\Rel\Comprovante.fr3');

  DataModule1.rel_Comprovante.ShowReport();

  btnRelatorio.Enabled := False;
  buscarTudoVendas;
end;

procedure TFrmVendas.btnSalvarClick(Sender: TObject);
begin

if lblTotalVenda.Caption > '0' then
begin
    DataModule1.tb_vendas.Insert;
    associarCamposVendas;
    DataModule1.tb_vendas.Post;
    MessageDlg('Venda Salva com sucesso!', mtInformation, mbOKCancel, 0);


     {INSERINDO A VENDA NA TABELA DE MOVIMENTAÇÕES}
        DataModule1.queryConMov.Close;
        DataModule1.queryConMov.SQL.Clear;
        DataModule1.queryConMov.SQL.Add('INSERT INTO movimentacoes (tipo, movimento, valor, funcionario, data) values (:tipo, :movimento, :valor, :funcionario, curDate())');
        DataModule1.queryConMov.ParamByName('tipo').Value :=  'Entrada';
        DataModule1.queryConMov.ParamByName('movimento').Value :=  'Venda';
        DataModule1.queryConMov.ParamByName('valor').Value :=  total_venda;
        DataModule1.queryConMov.ParamByName('funcionario').Value :=  nomeFuncionario;
        DataModule1.queryConMov.ExecSQL;


    {RELACIONAR O ID DA VENDA AOS ITENS}
      DataModule1.queryConVendas.Close;
      DataModule1.queryConVendas.SQL.Clear;
      DataModule1.queryConVendas.SQL.Add('select * from vendas order by id desc') ;
      DataModule1.queryConVendas.Open;

      ultimoId := DataModule1.queryConVendas['id'];
      EdtCodigoVenda.Text := ultimoId.ToString;


      DataModule1.queryConDetalhes.Close;
      DataModule1.queryConDetalhes.SQL.Clear;
      DataModule1.queryConDetalhes.SQL.Add('update detalhes_venda set id_venda = :id where id_venda = 0');
      DataModule1.queryConDetalhes.ParamByName('id').Value :=  ultimoId;
      DataModule1.queryConDetalhes.ExecSQL;

    LimparCampos();
    buscarTudoVendas;
    btnNovo.Enabled := true;
    btnSalvar.Enabled := false;
    btnAddItem.Enabled := false;
    lblTotalVenda.Caption := '0';
    total_venda := 0;


    gridVendas.Enabled := true;
grid.Enabled := false;

    end
    else
    begin
    MessageDlg('Adicione produtos a venda', mtInformation, mbOKCancel, 0);
end;
end;

procedure TFrmVendas.buscarData;
begin
  grid.Visible := False;
  gridVendas.Visible := True;
  DataModule1.queryConVendas.Close;
  DataModule1.queryConVendas.SQL.Clear;
  DataModule1.queryConVendas.SQL.Add('select * from vendas where data = :data order by id desc') ;
  DataModule1.queryConVendas.ParamByName('data').Value := FormatDateTime('yyyy/mm/dd', Data.Date);
  DataModule1.queryConVendas.Open
end;

procedure TFrmVendas.buscarTudo;
begin
  TFloatField(DataModule1.queryConDetalhes.FieldByName('valor')).DisplayFormat:='R$ #,,,,0.00';
  TFloatField(DataModule1.queryConDetalhes.FieldByName('valor_total')).DisplayFormat:='R$ #,,,,0.00';


  grid.Visible := true;
  gridVendas.Visible := false;
  DataModule1.queryConDetalhes.Close;
  DataModule1.queryConDetalhes.SQL.Clear;
  DataModule1.queryConDetalhes.SQL.Add('select * from detalhes_venda WHERE id_venda = 0 order by id desc') ;
  DataModule1.queryConDetalhes.Open
end;

procedure TFrmVendas.buscarTudoVendas;
begin
 TFloatField(DataModule1.queryConVendas.FieldByName('valor')).DisplayFormat:='R$ #,,,,0.00';

 grid.Visible := false;
 gridVendas.Visible := True;
 DataModule1.queryConVendas.Close;
 DataModule1.queryConVendas.SQL.Clear;
 DataModule1.queryConVendas.SQL.Add('select * from vendas where data = curDate() order by id desc') ;
 DataModule1.queryConVendas.Open;
end;

procedure TFrmVendas.DataChange(Sender: TObject);
begin
  buscarData;
end;

procedure TFrmVendas.FormActivate(Sender: TObject);
begin
  EdtNome.Text := nomeProduto;
  edtCodigo.Text := idProduto;
  EdtValor.Text := valorProduto;
  edtEstoque.Text := quantidadeProduto;


end;

procedure TFrmVendas.FormShow(Sender: TObject);
begin
  lblTotalVenda.Caption := FormatFloat('R$ #,,,,0.00', strToFloat(lblTotalVenda.Caption));


  DataModule1.tb_vendas.Active := False;
  DataModule1.tb_vendas.Active := True;
  DataModule1.tb_detalhes_vendas.Active := False;
  DataModule1.tb_detalhes_vendas.Active := True;

  btnSalvar.Enabled := false;
  btnDeletar.Enabled := false;
  btnAddItem.Enabled := false;
  btnRelatorio.Enabled := false;

  data.Date := Date;

  buscarTudoVendas;
end;

procedure TFrmVendas.gridCellClick(Column: TColumn);
begin
  btnDeletar.Enabled := True;

  if DataModule1.queryConDetalhes.FieldByName('valor_total').value then
  EdtQuantItem.Text := DataModule1.queryConDetalhes.FieldByName('valor_total').value;

  if DataModule1.queryConDetalhes.FieldByName('quantidade').value then
  edtQuanDetalhes.Text := DataModule1.queryConDetalhes.FieldByName('quantidade').value;

  if DataModule1.queryConDetalhes.FieldByName('id_produto').value then
  EdtCodigoVenda.Text := gridVendas.DataSource.DataSet.FieldByName('id_produto').value;//DataModule1.queryConDetalhes.FieldByName('id_produto').value;
end;

procedure TFrmVendas.gridVendasCellClick(Column: TColumn);
begin
  btnDeletar.Enabled := True;

  if DataModule1.queryConVendas.FieldByName('id').Value <> null then
  EdtCodigoVenda.Text := DataModule1.queryConVendas.FieldByName('id').Value;

  btnRelatorio.Enabled := true;
end;

procedure TFrmVendas.btnAddItemClick(Sender: TObject);
begin
if (edtNome.Text <> '') and (edtQuantidade.Text > '0') then
begin
    if strToFloat(edtEstoque.Text) >= strToFloat(edtQuantidade.Text) then
    begin
    DataModule1.tb_detalhes_vendas.Insert;
    associarCampos;
    DataModule1.tb_detalhes_vendas.Post;


    {ABATENDO QUANTIDADE NO ESTOQUE}
              quant := strToFloat(EdtEstoque.Text) - strToFloat(EdtQuantidade.Text);
              DataModule1.queryConProd.Close;
              DataModule1.queryConProd.SQL.Clear;
              DataModule1.queryConProd.SQL.Add('update produtos set quantidade = :quantidade where id = :id');
              DataModule1.queryConProd.ParamByName('quantidade').Value :=  quant;
              DataModule1.queryConProd.ParamByName('id').Value := edtCodigo.Text;
              DataModule1.queryConProd.ExecSQL;




    buscarTudo;
    LimparCampos();

    total_venda := total_venda + DataModule1.tb_detalhes_vendas.FieldByName('valor_total').Value;
    lblTotalVenda.Caption := FormatFloat('R$ #,,,,0.00', total_venda);



    end
    else
    begin
    MessageDlg('A quantidade não existe em estoque', mtInformation, mbOKCancel, 0);
    end;


end
else
begin
 MessageDlg('Selecione um produto e a quantidade', mtInformation, mbOKCancel, 0);
end;
end;

end.

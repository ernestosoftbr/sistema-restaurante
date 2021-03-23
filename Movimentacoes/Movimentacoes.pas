unit Movimentacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TFrmMovimentacoes = class(TForm)
    gridVendas: TDBGrid;
    dataInicial: TDateTimePicker;
    Label1: TLabel;
    dataFinal: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    cbEntradaSaida: TComboBox;
    ImgBack: TImage;
    Label4: TLabel;
    lblTotal: TLabel;
    lblEntradas: TLabel;
    lblVlrEntradas: TLabel;
    Label6: TLabel;
    lblVlrSaidas: TLabel;
    procedure FormShow(Sender: TObject);
    procedure dataInicialChange(Sender: TObject);
    procedure dataFinalChange(Sender: TObject);
    procedure cbEntradaSaidaChange(Sender: TObject);
  private
    { Private declarations }
    procedure buscarTudo;
    procedure buscarData;
    procedure totalizarEntradas;
    procedure totalizarSaidas;
    procedure totalizar;
    procedure formatarGrid;
  public
    { Public declarations }
  end;

var
  FrmMovimentacoes: TFrmMovimentacoes;
  TotEntradas: real;
  TotSaidas: real;

implementation

uses
  modulo;

{$R *.dfm}

procedure TFrmMovimentacoes.buscarData;
begin

totalizarEntradas;
totalizarSaidas;
totalizar;


 DataModule1.queryConMov.Close;
  DataModule1.queryConMov.SQL.Clear;
  if cbEntradaSaida.Text = 'Tudo' then
  begin
    DataModule1.queryConMov.SQL.Add('select * from movimentacoes where data >= :dataInicial and data <= :dataFinal order by id desc') ;
    end
    else
    begin
     DataModule1.queryConMov.SQL.Add('select * from movimentacoes where data >= :dataInicial and data <= :dataFinal and tipo = :tipo order by id desc') ;
     DataModule1.queryConMov.ParamByName('tipo').Value :=  cbEntradaSaida.Text;
  end;


  DataModule1.queryConMov.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
  DataModule1.queryConMov.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
  DataModule1.queryConMov.Open;
  formatarGrid;
end;

procedure TFrmMovimentacoes.buscarTudo;
begin
    totalizarEntradas;
    totalizarSaidas;
    totalizar;

  DataModule1.queryConMov.Close;
  DataModule1.queryConMov.SQL.Clear;
  DataModule1.queryConMov.SQL.Add('select * from movimentacoes WHERE data = curDate() order by id desc') ;
  DataModule1.queryConMov.Open;
  TFloatField(DataModule1.queryConMov.FieldByName('valor')).DisplayFormat:='R$ #,,,,0.00';
  formatarGrid;
end;

procedure TFrmMovimentacoes.cbEntradaSaidaChange(Sender: TObject);
begin
buscarData;
end;

procedure TFrmMovimentacoes.dataFinalChange(Sender: TObject);
begin
buscarData;
end;

procedure TFrmMovimentacoes.dataInicialChange(Sender: TObject);
begin
buscarData;
end;

procedure TFrmMovimentacoes.formatarGrid;
begin
gridVendas.Columns.Items[0].FieldName := 'id';
gridVendas.Columns.Items[0].Title.Caption := 'Id';
gridVendas.Columns.Items[0].Visible := false;

gridVendas.Columns.Items[1].FieldName := 'tipo';
gridVendas.Columns.Items[1].Title.Caption := 'Tipo';

gridVendas.Columns.Items[2].FieldName := 'movimento';
gridVendas.Columns.Items[2].Title.Caption := 'Movimento';

gridVendas.Columns.Items[3].FieldName := 'valor';
gridVendas.Columns.Items[3].Title.Caption := 'Valor';

gridVendas.Columns.Items[4].FieldName := 'funcionario';
gridVendas.Columns.Items[4].Title.Caption := 'Funcionário';

gridVendas.Columns.Items[5].FieldName := 'data';
gridVendas.Columns.Items[5].Title.Caption := 'Data';
end;

procedure TFrmMovimentacoes.FormShow(Sender: TObject);
begin
  lblVlrEntradas.Caption := FormatFloat('R$ #,,,,0.00', StrToFloat(lblVlrEntradas.Caption));
  lblVlrSaidas.Caption := FormatFloat('R$ #,,,,0.00', StrToFloat(lblVlrSaidas.Caption));
  lblTotal.Caption := FormatFloat('R$ #,,,,0.00', StrToFloat(lblTotal.Caption));

  cbEntradaSaida.ItemIndex := 0;

  DataModule1.tb_movimentacoes.Active := False;
  DataModule1.tb_movimentacoes.Active := True;

  DataInicial.Date := Date;
  DataFinal.Date := Date;
  totalizarEntradas;
  buscarTudo;
end;

procedure TFrmMovimentacoes.totalizar;
var
tot: real;
begin
  tot := TotEntradas - TotSaidas;
  if tot >= 0 then
  begin
    lblTotal.Font.Color := clGreen;
  end
  else
  begin
    lblTotal.Font.Color := clRed;
  end;

lblTotal.Caption := FormatFloat('R$ #,,,,0.00', tot);

end;

procedure TFrmMovimentacoes.totalizarEntradas;
var
tot: real;
begin
  DataModule1.queryConMov.Close;
  DataModule1.queryConMov.SQL.Clear;
  DataModule1.queryConMov.SQL.Add('select sum(valor) as total from movimentacoes where data >= :dataInicial and data <= :dataFinal and tipo = "Entrada" ') ;
  DataModule1.queryConMov.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
  DataModule1.queryConMov.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
  DataModule1.queryConMov.Prepare;
  DataModule1.queryConMov.Open;
  tot := DataModule1.queryConMov.FieldByName('total').AsFloat;
  TotEntradas := tot;
  lblVlrEntradas.Caption := FormatFloat('R$ #,,,,0.00', tot);
end;

procedure TFrmMovimentacoes.totalizarSaidas;
var
tot: real;
begin
  DataModule1.queryConMov.Close;
  DataModule1.queryConMov.SQL.Clear;
  DataModule1.queryConMov.SQL.Add('select sum(valor) as total from movimentacoes where data >= :dataInicial and data <= :dataFinal and tipo = "Saída" ') ;
  DataModule1.queryConMov.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
  DataModule1.queryConMov.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
  DataModule1.queryConMov.Prepare;
  DataModule1.queryConMov.Open;
  tot := DataModule1.queryConMov.FieldByName('total').AsFloat;
  TotSaidas := tot;
  lblVlrSaidas.Caption := FormatFloat('R$ #,,,,0.00', tot);

end;

end.

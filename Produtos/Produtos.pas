unit Produtos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ExtDlgs;

type
  TFrmProdutos = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    EdtNome: TEdit;
    EdtValor: TEdit;
    cbFornecedor: TComboBox;
    grid: TDBGrid;
    edtCodigo: TEdit;
    EdtBuscarNome: TEdit;
    EdtDescricao: TEdit;
    EdtQuantidade: TEdit;
    Label4: TLabel;
    imagem: TImage;
    btnAddImg: TButton;
    dialog: TOpenPictureDialog;
    ImgBack: TImage;
    procedure btnAddImgClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure EdtBuscarNomeChange(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
  private
    { Private declarations }
     procedure associarCampos;
    procedure buscarTudo;
    procedure buscarNome;
    procedure carregarCombobox;
    procedure salvarFoto;
  public
    { Public declarations }
  end;

var
  FrmProdutos: TFrmProdutos;
  caminhoImg: String;
  img : TPicture;
  alterou: boolean;
implementation

{$R *.dfm}

uses modulo;






procedure CarregarImagemPadrao();
begin
    caminhoImg  := ExtractFileDir(GetCurrentDir) + '\Debug\img\sem-foto.jpg';
    FrmProdutos.imagem.Picture.LoadFromFile(caminhoImg);

end;



procedure LimparCampos();
begin

    CarregarImagemPadrao();
    With FrmProdutos do

    begin

    EdtNome.Text := '';
    EdtDescricao.Text := '';
    EdtValor.Text := '0';


    end
end;


procedure HabilitarCampos();
begin
    With FrmProdutos do

    begin
    EdtNome.Enabled := True;
    EdtDescricao.Enabled := True;
    EdtValor.Enabled := True;

    cbFornecedor.Enabled := True;
    btnAddImg.Enabled := True;
    end
end;


procedure DesabilitarCampos();
begin
    With FrmProdutos do

    begin
    LimparCampos;
   EdtNome.Enabled := False;
    EdtDescricao.Enabled := False;
    EdtValor.Enabled := False;

    cbFornecedor.Enabled := False;
    btnAddImg.Enabled := False;

    btnSalvar.Enabled := false;
    btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
    end
end;




procedure TFrmProdutos.associarCampos;
begin
 DataModule1.tb_produtos.FieldByName('nome').Value := edtNome.text;
 DataModule1.tb_produtos.FieldByName('descricao').Value := EdtDescricao.text;
 DataModule1.tb_produtos.FieldByName('quantidade').Value := EdtQuantidade.text;
 DataModule1.tb_produtos.FieldByName('valor').Value := StringReplace(edtValor.text, '.', ',', []);
 DataModule1.tb_produtos.FieldByName('fornecedor').Value := Integer(cbFornecedor.Items.Objects[cbFornecedor.ItemIndex]);

end;

procedure TFrmProdutos.btnAddImgClick(Sender: TObject);
begin
dialog.Execute();
imagem.Picture.LoadFromFile(dialog.FileName);
alterou := true;

end;

procedure TFrmProdutos.btnDeletarClick(Sender: TObject);
begin
 if MessageDlg('Deseja Excluir o Registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then

        begin
             if edtCodigo.Text <> '' then

                begin
               {SALVANDO OS DADOS}
                {DataModule1.tb_produtos.Delete; }
                 associarCampos;

              DataModule1.queryConProd.Close;
              DataModule1.queryConProd.SQL.Clear;
              DataModule1.queryConProd.SQL.Add('DELETE FROM produtos WHERE id = :id');
              DataModule1.queryConProd.ParamByName('id').Value := edtCodigo.Text;
              DataModule1.queryConProd.ExecSQL;


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

procedure TFrmProdutos.btnEditarClick(Sender: TObject);
begin

DataModule1.tb_produtos.Edit;
if (edtNome.Text <> '') then

         begin
             {SALVANDO OS DADOS}
              associarCampos;



              DataModule1.queryConProd.Close;
              DataModule1.queryConProd.SQL.Clear;

              if alterou = false then
              begin
                DataModule1.queryConProd.SQL.Add('update produtos set nome = :nome, descricao = :descricao, valor = :valor, fornecedor = :fornecedor where id = :id');
              end
              else
              begin
                DataModule1.queryConProd.SQL.Add('update produtos set nome = :nome, descricao = :descricao, valor = :valor, fornecedor = :fornecedor, imagem = :imagem where id = :id');
                img := TPicture.Create;
                img.LoadFromFile(dialog.FileName);
                DataModule1.queryConProd.ParamByName('imagem').Assign(img);
                img.Free;
                alterou := false;
              end;



              DataModule1.queryConProd.ParamByName('nome').Value := edtNome.Text;
              DataModule1.queryConProd.ParamByName('descricao').Value := edtDescricao.Text;
              DataModule1.queryConProd.ParamByName('valor').Value := StringReplace(edtValor.text, '.', ',', []);
              DataModule1.queryConProd.ParamByName('fornecedor').Value := Integer(cbFornecedor.Items.Objects[cbFornecedor.ItemIndex]);

              DataModule1.queryConProd.ParamByName('id').Value := edtCodigo.Text;
              DataModule1.queryConProd.ExecSQL;



              MessageDlg('Alterado com Sucesso', mtInformation, mbOKCancel, 0);
              dialog.FileName := ExtractFileDir(GetCurrentDir) + '\Debug\img\sem-foto.jpg';
              buscarTudo;
              LimparCampos();
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

procedure TFrmProdutos.btnNovoClick(Sender: TObject);
begin

HabilitarCampos();
LimparCampos();
btnSalvar.Enabled := True;
edtNome.SetFocus;

DataModule1.tb_produtos.Insert;

BtnNovo.Enabled := False;
grid.Enabled := False;

btnEditar.Enabled := False;
btnDeletar.Enabled := False;
end;

procedure TFrmProdutos.btnSalvarClick(Sender: TObject);
begin
if (edtNome.Text <> '') and (EdtDescricao.Text <> '   .   .   -  ') then

         begin
              associarCampos;

              salvarFoto;
              DataModule1.tb_produtos.Post;
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

procedure TFrmProdutos.buscarNome;
begin
DataModule1.queryConProd.Close;
  DataModule1.queryConProd.SQL.Clear;
  DataModule1.queryConProd.SQL.Add('select p.id, p.nome, p.descricao, p.valor, p.quantidade, p.fornecedor, f.nome, p.imagem from produtos as p INNER JOIN fornecedores as f ON p.fornecedor = f.id where p.nome LIKE :nome order by p.nome asc') ;
  DataModule1.queryConProd.ParamByName('nome').Value := EdtBuscarNome.Text + '%';
  DataModule1.queryConProd.Open;
end;

procedure TFrmProdutos.buscarTudo;
begin
    DataModule1.queryConProd.Close;
  DataModule1.queryConProd.SQL.Clear;
  DataModule1.queryConProd.SQL.Add('select p.id, p.nome, p.descricao, p.valor, p.quantidade, p.fornecedor, f.nome, p.imagem from produtos as p INNER JOIN fornecedores as f ON p.fornecedor = f.id order by id desc') ;
  DataModule1.queryConProd.Open;
end;

procedure TFrmProdutos.carregarCombobox;
begin
With DataModule1.tb_fornecedores do
    begin



      if not isEmpty then
      begin
          while not Eof do
          begin
            cbFornecedor.Items.AddObject(FieldByName('nome').AsString, TObject(FieldByName('id').AsInteger));

            Next;

          end;

      end;
      end;
end;

procedure TFrmProdutos.EdtBuscarNomeChange(Sender: TObject);
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

procedure TFrmProdutos.FormShow(Sender: TObject);
begin
    CarregarImagemPadrao();

DataModule1.tb_fornecedores.Active := False;
DataModule1.tb_fornecedores.Active := True;
DataModule1.tb_produtos.Active := False;
DataModule1.tb_produtos.Active := True;
buscarTudo;
carregarCombobox;
cbFornecedor.ItemIndex := 0;
dialog.FileName := ExtractFileDir(GetCurrentDir) + '\Debug\img\sem-foto.jpg';

end;



{PROCEDIMENTO PADRÃO PARA RECUPERAR FOTO DO BANCO}
procedure ExibeFoto(DataSet : TDataSet; BlobFieldName : String; ImageExibicao :
TImage);

 var MemoryStream:TMemoryStream; jpg : TPicture;
 const
  OffsetMemoryStream : Int64 = 0;

begin
  if not(DataSet.IsEmpty) and
  not((DataSet.FieldByName(BlobFieldName) as TBlobField).IsNull) then
    try
      MemoryStream := TMemoryStream.Create;
      Jpg := TPicture.Create;
      (DataSet.FieldByName(BlobFieldName) as
TBlobField).SaveToStream(MemoryStream);
      MemoryStream.Position := OffsetMemoryStream;
      Jpg.LoadFromStream(MemoryStream);
      ImageExibicao.Picture.Assign(Jpg);
    finally
     // Jpg.Free;
      MemoryStream.Free;
    end
  else
    ImageExibicao.Picture := Nil;
end;



procedure TFrmProdutos.gridCellClick(Column: TColumn);
begin
HabilitarCampos();
btnEditar.Enabled := True;
btnDeletar.Enabled := True;

DataModule1.tb_produtos.Edit;


if DataModule1.queryConProd.FieldByName('nome').Value <> null then
EdtNome.Text := DataModule1.queryConProd.FieldByName('nome').Value ;

if DataModule1.queryConProd.FieldByName('descricao').Value <> null then
EdtDescricao.Text := DataModule1.queryConProd.FieldByName('descricao').Value ;

if DataModule1.queryConProd.FieldByName('quantidade').Value <> null then
EdtQuantidade.Text := DataModule1.queryConProd.FieldByName('quantidade').Value ;


if DataModule1.queryConProd.FieldByName('valor').Value <> null then
EdtValor.Text := DataModule1.queryConProd.FieldByName('valor').Value ;

if DataModule1.queryConProd.FieldByName('fornecedor').Value <> null then
cbFornecedor.Text := DataModule1.queryConProd.FieldByName('nome_1').Value;


if DataModule1.queryConProd.FieldByName('imagem').Value <> null then
ExibeFoto(DataModule1.queryConProd, 'imagem', imagem);


EdtCodigo.Text := DataModule1.queryConProd.FieldByName('id').Value ;


end;

procedure TFrmProdutos.gridDblClick(Sender: TObject);
begin
  nomeProduto := EdtNome.Text;
  idProduto := edtCodigo.Text;
  quantidadeproduto := EdtQuantidade.Text;
  valorProduto := EdtValor.Text;

  FrmProdutos.Close;
end;

procedure TFrmProdutos.salvarFoto;
begin
  if dialog.FileName <> '' then
  begin
  img := TPicture.Create;
  img.LoadFromFile(dialog.FileName);
  DataModule1.tb_produtos.FieldByName('imagem').Assign(img);
  img.Free;
  dialog.FileName := ExtractFileDir(GetCurrentDir) + '\Debug\img\sem-foto.jpg';
  alterou := false;
  end
  else
    begin
  DataModule1.tb_produtos.FieldByName('imagem').Value := ExtractFileDir(GetCurrentDir) + '\Debug\img\sem-foto.jpg';

  end;

end;

end.

*&---------------------------------------------------------------------*
*& Report ZREL_NF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREL_NF.

tables: j_1bnfdoc.

SELECTION-SCREEN BEGIN OF BLOCK B1.

    SELECT-OPTIONS: SO_EMP  FOR j_1bnfdoc-bukrs,
                    SO_fili FOR j_1bnfdoc-bukrs,
                    so_data for j_1bnfdoc-docdat,
                    so_pari for j_1bnfdoc-parid.

SELECTION-SCREEN END OF BLOCK B1.

START-OF-SELECTION.
  PERFORM f_seleciona_dados.


*&---------------------------------------------------------------------*
*& Form f_seleciona_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_seleciona_dados .

  data: li_fieldcat type SLIS_T_FIELDCAT_ALV.

  select doc~docnum, doc~bukrs, doc~branch, doc~nfenum, doc~series, doc~parid, doc~vliq, act~docsta
    into TABLE @data(li_rel)
    from j_1bnfdoc as doc
    INNER JOIN j_1bnfe_active as act
    on act~docnum = doc~docnum
    where doc~bukrs  in @so_emp
      and doc~branch in @so_fili
      and doc~docdat in @so_data
      and doc~parid  in @so_pari
      and doc~cancel = ''
      and doc~model  = '55'.

  PERFORM f_monta_catalogo_campos CHANGING li_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      IT_FIELDCAT                       = li_fieldcat
    TABLES
      t_outtab                          = li_rel.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_monta_catalogo_campos
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LI_FIELDCAT
*&---------------------------------------------------------------------*
FORM f_monta_catalogo_campos  CHANGING p_fieldcat type slis_t_fieldcat_alv.

  p_fieldcat[] = value #(
                          ( fieldname = 'docnum' seltext_l = 'NF_ID' seltext_m = 'NF_ID' seltext_s = 'NF_ID' )
                          ( fieldname = 'bukrs'  seltext_l = 'Empresa' seltext_m = 'Empresa' seltext_s = 'Empresa' )
                          ( fieldname = 'branch' seltext_l = 'Filial' seltext_m = 'Filial' seltext_s = 'Filial' )
                          ( fieldname = 'nfenum' seltext_l = 'Número da NF-e' seltext_m = 'Número NF-e' seltext_s = 'N° NF-e' )
                          ( fieldname = 'series' seltext_l = 'Série da NF-e' seltext_m = 'Série NF-e' seltext_s = 'Série' )
                          ( fieldname = 'parid'  seltext_l = 'Código do destinatário/parceiro' seltext_m = 'Código dest/par' seltext_s = 'Cod. dest/par' )
                          ( fieldname = 'vliq'   seltext_l = 'Valor total do documento' seltext_m = 'Valor do documento' seltext_s = 'Valor total' )
                          ( fieldname = 'docsta' seltext_l = 'Status da SEFAZ' seltext_m = 'Status da SEFAZ' seltext_s = 'Status SEFAZ' )
                         ).

ENDFORM.
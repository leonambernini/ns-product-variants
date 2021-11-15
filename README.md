# ns-product-variants
Recurso adicional para que o lojista tenha opção via painel (personalização da loja) de manipular a exibição das variações, este recurso permite as seguintes opções de manipulação:

- **Desmarcar opção padrão?**
Campo de seleção responsável por desmarcar a opção padrão das variações quando houver mais de uma opção, adicionando um `<option value="">Selecione</option>`
- **Desmarcar opção padrão para variação com apenas 1 opção?**
Campo de seleção responsável por desmarcar a opção padrão das variações quando houver apenas uma opção, tornando obrigatório o cliente selecionar a opção, mesmo que única.
- **Esconder variação com apenas 1 opção?**
Campo de seleção responsável por esconder o select da variação quando houver apenas uma opção, esta opção só funciona quando a opção `Desmarcar opção padrão para variação com apenas 1 opção?` estiver **`DESMARCADA`**

# Instalação via tema base

Para instalar no tema base da Nuvem Shop basta clonar este repositório e substituir os arquivos do tema
Tema utilizado como referencia [TiendaNube/base-theme](https://github.com/TiendaNube/base-theme).




# Instalação manual

O código deve ser instalado via FTP atualizando dois arquivos padrões da Nuvem Shop.

- config/settings.txt
- snipplets/product/product-variants.tpl


## Primeiro arquivo: settings.txt

Abra o arquivo settings.txt busque pela sessão `Detalle de producto`
Apos a opção `META` adicione o seguinte código:

```sh
title
    title = Opções de variações
checkbox
    name = lb_variants_deselect_default
    description = Desmarcar opção padrão?
checkbox
    name = lb_variants_deselect_default_with_one_option
    description = Desmarcar opção padrão para variação com apenas 1 opção?
checkbox
    name = lb_variants_hide_select_with_one_option
    description = Esconder variação com apenas 1 opção? <span class="d-block text-danger">Esta opção só funciona quando a opção <i><b>Desmarcar opção padrão para variação com apenas 1 opção?</b></i> estiver <b>DESMARCADA</b></span>
```

## Segundo arquivo: product-variants.tpl

Neste arquivo vamos utilizar as variáveis que criamos em settings.txt  para definir as opções das variações.

Temos 3 variáveis para utilizarmos:

- **lb_variants_deselect_default** = Se marcada devemos adicionar a opção `Selecione` ao select da variação;
- **lb_variants_deselect_default_with_one_option** = Se marcada devemos adicionar a opção `Selecione`tambem ao select da variação mesmo que tenha apenas 1 opção;
- **lb_variants_hide_select_with_one_option** = Se marcada devemos esconder a variação quando houver apenas 1 opção, esta opção é ignorada caso `lb_variants_deselect_default_with_one_option` esteja marcada.

No começo do arquivo product-variants.tpl vamos inserir o seguinte código:

```sh
{% set deselect_default = settings.lb_variants_deselect_default | default(false) %}
{% set deselect_default_with_one_option = settings.lb_variants_deselect_default_with_one_option | default(false) %}
{% set hide_select_with_one_option = settings.lb_variants_hide_select_with_one_option | default(false) %}
{% set hide_select = hide_select_with_one_option and not deselect_default_with_one_option %}
```

Agora devemos localizar o “looping” responsável por criar as variações `{% for variation in product.variations %}`, neste "looping" devemos adicionar uma verificação e um elemento `div` com `display: none;`para esconder o select, o código deve ficar basicamente assim.

```sh
{% if variation.options | length == 1 and hide_select %}
    <div style="display: none;">
{% endif %}

... Código atual responsável por criar os selects ...

{% if variation.options | length == 1 and hide_select %}
    </div>
{% endif %}
```

Agora iremos colocar as validações para remover a opção padrão da variação, para isso devemos encontrar o código responsável pelo "looping" das opções das variações `{% for option in variation.options %}` e adicionarmos os seguintes códigos:


Antes do "looping" devemos inserir o seguinte código:

```sh
{% set deselect_option = ( deselect_default and variation.options | length > 1 ) or ( deselect_default and deselect_default_with_one_option ) %}
{% if deselect_option %}
    <option value="" select="selected">{{ 'Selecione' | translate }}</option>
{% endif %}
```

E por fim iremos localizar o seguinte código `{% if product.default_options[variation.id] == option.id %}selected="selected"{% endif %}` e substituir por:

```sh
{% if product.default_options[variation.id] == option.id and not deselect_option %}selected="selected"{% endif %}
```

**Lembrando que dependendo do seu código `product-variants.tpl` pode ter mais de uma opçõe de select, com isso deve ser adicionado o código em todas as opções.**




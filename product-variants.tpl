{% set deselect_default = settings.lb_variants_deselect_default | default(false) %}
{% set deselect_default_with_one_option = settings.lb_variants_deselect_default_with_one_option | default(false) %}
{% set hide_select_with_one_option = settings.lb_variants_hide_select_with_one_option | default(false) %}
{% set hide_select = hide_select_with_one_option and not deselect_default_with_one_option %}

<div class="js-product-variants{% if quickshop %} js-product-quickshop-variants text-left{% endif %} form-row">
	{% for variation in product.variations %}
        {% if variation.options | length == 1 and hide_select %}
			<div style="display: none;">
		{% endif %}
		<div class="js-product-variants-group {% if variation.name in ['Color', 'Cor'] %}js-color-variants-container{% endif %} {% if loop.length == 3 %} {% if quickshop %}col-4{% else %}col-12{% endif %} col-md-4 {% elseif loop.length == 2 %} col-6 {% else %} col {% if quickshop %}col-md-12{% else %}col-md-6{% endif %}{% endif %}">
			{% embed "snipplets/forms/form-select.tpl" with{select_label: true, select_label_name: '' ~ variation.name ~ '', select_for: 'variation_' ~ loop.index , select_data: 'variant-id', select_data_value: 'variation_' ~ loop.index, select_name: 'variation' ~ '[' ~ variation.id ~ ']', select_custom_class: 'js-variation-option js-refresh-installment-data'} %}
				{% block select_options %}
                    {% set deselect_option = ( deselect_default and variation.options | length > 1 ) or ( deselect_default and deselect_default_with_one_option ) %}
                    {% if deselect_option %}
                        <option value="" select="selected">{{ 'Selecione' | translate }}</option>
                    {% endif %}
					{% for option in variation.options %}
						<option value="{{ option.id }}" {% if product.default_options[variation.id] == option.id and not deselect_option %}selected="selected"{% endif %}>{{ option.name }}</option>
					{% endfor %}
				{% endblock select_options%}
			{% endembed %}
		</div>
        {% if variation.options | length == 1 and hide_select %}
			</div>
		{% endif %}
	{% endfor %}
</>
CREATE OR REPLACE VIEW show_all_product_examples AS
SELECT pe.id id, product.name product, design.name design, kind.name kind, pe.name name,
  ce.name fabric, pe.SCU ___SCU___
FROM product_examples pe
LEFT JOIN product_category as product on product.id = pe.prod_cat_id
LEFT JOIN product_designs as design on design.id = pe.prod_design_id
LEFT JOIN product_types as kind on kind.id = pe.prod_type_id
LEFT JOIN product_components as pc on pc.prod_xmpl_id = pe.id -- AND pc.prod_comp_xmpl_id > 6 AND pc.prod_comp_xmpl_id < 11
LEFT JOIN components_examples as ce on ce.id = pc.prod_comp_xmpl_id AND ce.type_id = 3
ORDER BY kind;
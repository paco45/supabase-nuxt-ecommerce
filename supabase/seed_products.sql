INSERT INTO products (
  name, slug, "unitPrice", currency, "shortDescription", description,
  "primaryImage", "imageUrls", "skincareCategory", "primaryCategoryId",
  "stockQuantity", ingredients, "howToUse", volume, "skinType",
  "isFeatured", discount, "createdAt"
) VALUES

-- 1. Sérum Vitamina C
(
  'Sérum Vitamina C 15%',
  'serum-vitamina-c-15',
  89900, 'COP',
  'Ilumina y unifica el tono con vitamina C estabilizada al 15%.',
  'Nuestro sérum de vitamina C es la solución perfecta para piel apagada y manchas. Con una fórmula estabilizada de ácido ascórbico al 15%, vitamina E y ácido ferúlico que potencian su acción antioxidante. Uso diario para una piel más luminosa en 4 semanas.',
  'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&q=80','https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=600&q=80'],
  'Sérums', 3,
  45,
  'Aqua, Ascorbic Acid 15%, Vitamin E, Ferulic Acid, Hyaluronic Acid, Niacinamide, Glycerin',
  'Aplica 3-4 gotas en el rostro limpio por la mañana. Deja absorber 1 minuto antes del hidratante. Siempre usa protector solar después.',
  '30ml',
  ARRAY['Normal','Mixta','Grasa'],
  true, NULL, NOW() - INTERVAL '10 days'
),

-- 2. Sérum Retinol
(
  'Sérum Retinol 0.5%',
  'serum-retinol-05',
  112000, 'COP',
  'Antiedad de noche con retinol encapsulado para mínima irritación.',
  'Retinol microencapsulado al 0.5% para una liberación gradual que minimiza la irritación. Estimula la renovación celular, reduce líneas finas y unifica la textura. Ideal para comenzar con retinol o pieles que buscan resultados sin el efecto descamación.',
  'https://images.unsplash.com/photo-1601049676869-702ea24cfd58?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1601049676869-702ea24cfd58?w=600&q=80'],
  'Sérums', 3,
  30,
  'Retinol (Encapsulated) 0.5%, Squalane, Peptides, Ceramides, Niacinamide, Bakuchiol',
  'Aplica 2-3 gotas en el rostro limpio solo de noche. Comienza 2 veces por semana, aumenta gradualmente. Hidrata después.',
  '30ml',
  ARRAY['Normal','Seca','Mixta'],
  true, NULL, NOW() - INTERVAL '8 days'
),

-- 3. Limpiador gel
(
  'Gel Limpiador Ácido Salicílico',
  'gel-limpiador-acido-salicilico',
  54900, 'COP',
  'Limpieza profunda con ácido salicílico 0.5% para poros limpios.',
  'Gel limpiador con ácido salicílico al 0.5% que penetra los poros para eliminar el exceso de sebo y células muertas. Fórmula suave con niacinamida que limpia sin resecar. pH 5.5 que respeta la barrera cutánea.',
  'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=600&q=80'],
  'Limpiadores', 1,
  60,
  'Aqua, Salicylic Acid 0.5%, Niacinamide, Zinc PCA, Aloe Vera, Glycerin, Panthenol',
  'Aplica sobre el rostro húmedo, masajea en círculos por 60 segundos, enjuaga con agua tibia. Usar mañana y noche.',
  '150ml',
  ARRAY['Grasa','Mixta'],
  false, NULL, NOW() - INTERVAL '7 days'
),

-- 4. Limpiador crema
(
  'Limpiador Crema Piel Sensible',
  'limpiador-crema-piel-sensible',
  48900, 'COP',
  'Limpieza suave con centella y avena para pieles delicadas.',
  'Limpiador en formato crema ultra suave, especialmente diseñado para pieles sensibles y secas. Con extracto de centella asiática y avena coloidal que calman y protegen la barrera cutánea mientras limpian con delicadeza.',
  'https://images.unsplash.com/photo-1608248597279-f99d160bfcbc?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1608248597279-f99d160bfcbc?w=600&q=80'],
  'Limpiadores', 1,
  40,
  'Aqua, Colloidal Oat, Centella Asiatica, Ceramides, Glycerin, Allantoin, Panthenol',
  'Aplica sobre el rostro seco o húmedo, masajea suavemente y enjuaga. Puede usarse como limpiador de arrastre de maquillaje.',
  '150ml',
  ARRAY['Sensible','Seca'],
  false, NULL, NOW() - INTERVAL '6 days'
),

-- 5. Protector solar
(
  'Protector Solar SPF 50+ Tono',
  'protector-solar-spf50-tono',
  78900, 'COP',
  'SPF 50+ con tono natural, acabado sémi-mate y sin residuo blanco.',
  'Protector solar de amplio espectro SPF 50+ con ligero tono adaptable que unifica la piel. Tecnología de filtros UV de última generación. Sin residuo blanco, acabado sémi-mate ideal para uso diario bajo maquillaje o solo.',
  'https://images.unsplash.com/photo-1526758097130-bab247274f58?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1526758097130-bab247274f58?w=600&q=80'],
  'Protección Solar', 5,
  55,
  'Homosalate, Octisalate, Octocrylene, Avobenzone, Tinosorb S, Niacinamide, Iron Oxides',
  'Aplica como último paso de tu rutina de mañana. Usa media cucharadita para el rostro. Reaplicar cada 2 horas en exposición directa.',
  '50ml',
  ARRAY['Normal','Mixta','Grasa','Sensible'],
  true, 10, NOW() - INTERVAL '5 days'
),

-- 6. Hidratante ácido hialurónico
(
  'Crema Hidratante Ácido Hialurónico',
  'crema-hidratante-acido-hialuronico',
  67500, 'COP',
  'Hidratación profunda con 3 pesos moleculares de ácido hialurónico.',
  'Crema ligera con triple peso molecular de ácido hialurónico que actúa en las diferentes capas de la piel. Textura gel-crema de absorción rápida, sin sensación grasa. Con ceramidas para reforzar la barrera cutánea y mantener la hidratación 24 horas.',
  'https://images.unsplash.com/photo-1612817288484-6f916006741a?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1612817288484-6f916006741a?w=600&q=80'],
  'Hidratantes', 4,
  50,
  'Aqua, Hyaluronic Acid (3 molecular weights), Ceramides, Glycerin, Niacinamide, Peptides, Squalane',
  'Aplica sobre el rostro limpio y ligeramente húmedo mañana y noche. Extiende con movimientos ascendentes hasta absorción completa.',
  '50ml',
  ARRAY['Normal','Seca','Mixta','Sensible'],
  true, NULL, NOW() - INTERVAL '4 days'
),

-- 7. Tónico AHA/BHA
(
  'Tónico Exfoliante AHA/BHA',
  'tonico-exfoliante-aha-bha',
  59900, 'COP',
  'Exfoliación química suave con glicólico y salicílico para piel renovada.',
  'Tónico exfoliante con 10% de ácido glicólico y 0.5% de ácido salicílico. Elimina células muertas, desbloquea poros y mejora la textura de la piel. Con witch hazel y rosa mosqueta para equilibrar.',
  'https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=600&q=80'],
  'Tónicos', 2,
  35,
  'Aqua, Glycolic Acid 10%, Salicylic Acid 0.5%, Witch Hazel, Rosehip, Aloe Vera, Glycerin',
  'Aplica con algodón o palmas sobre el rostro limpio por la noche. Comenzar 2 veces por semana. No usar con retinol la misma noche.',
  '200ml',
  ARRAY['Normal','Mixta','Grasa'],
  false, NULL, NOW() - INTERVAL '3 days'
),

-- 8. Mascarilla arcilla
(
  'Mascarilla Arcilla Verde Detox',
  'mascarilla-arcilla-verde-detox',
  45900, 'COP',
  'Mascarilla purificante con arcilla verde y carbón activado para poros limpios.',
  'Mascarilla de arcilla verde con carbón activado y extracto de árbol de té. Absorbe el exceso de sebo, purifica los poros y desintoxica la piel en solo 10 minutos. Con aloe vera para evitar el resecamiento.',
  'https://images.unsplash.com/photo-1570194065650-d99fb4a8b1a6?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1570194065650-d99fb4a8b1a6?w=600&q=80'],
  'Mascarillas', 7,
  28,
  'Kaolin, Bentonite, Activated Charcoal, Tea Tree Oil, Aloe Vera, Glycerin, Zinc PCA',
  'Aplica una capa uniforme sobre el rostro limpio evitando contorno de ojos y labios. Deja actuar 10-15 minutos, enjuaga con agua tibia. Usar 1-2 veces por semana.',
  '100ml',
  ARRAY['Grasa','Mixta'],
  false, 15, NOW() - INTERVAL '2 days'
),

-- 9. Contorno de ojos
(
  'Contorno de Ojos Cafeína + Péptidos',
  'contorno-ojos-cafeina-peptidos',
  95000, 'COP',
  'Reduce ojeras y bolsas con cafeína al 5% y péptidos tensores.',
  'Tratamiento específico para el área de los ojos con cafeína al 5% que reduce las bolsas y la retención de líquidos. Los péptidos MATRIXYL 3000 estimulan la síntesis de colágeno para suavizar líneas de expresión. Textura ultra ligera de absorción inmediata.',
  'https://images.unsplash.com/photo-1556228841-a3c527ebefe5?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1556228841-a3c527ebefe5?w=600&q=80'],
  'Contorno de Ojos', 6,
  20,
  'Aqua, Caffeine 5%, Matrixyl 3000, Peptides, Hyaluronic Acid, Arnica, Vitamin K, Glycerin',
  'Aplica una pequeña cantidad con el dedo anular dando toquecitos suaves alrededor del ojo. Usar mañana y noche.',
  '15ml',
  ARRAY['Normal','Seca','Mixta','Sensible'],
  true, NULL, NOW() - INTERVAL '1 day'
),

-- 10. Kit rutina básica
(
  'Kit Rutina Básica 3 Pasos',
  'kit-rutina-basica-3-pasos',
  159900, 'COP',
  'Limpiador + Hidratante + Protector Solar. Todo lo que necesitas para empezar.',
  'El kit perfecto para quienes quieren comenzar una rutina de skincare efectiva. Incluye el Gel Limpiador, la Crema Hidratante con Ácido Hialurónico y el Protector Solar SPF 50+. Los 3 productos esenciales que toda rutina debe tener, a un precio especial.',
  'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=600&q=80',
  ARRAY['https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=600&q=80'],
  'Kits', 10,
  15,
  'Ver productos individuales',
  'Mañana: Limpiador → Hidratante → Protector Solar. Noche: Limpiador → Hidratante.',
  '3 productos',
  ARRAY['Normal','Mixta','Grasa','Seca','Sensible'],
  true, 20, NOW()
);

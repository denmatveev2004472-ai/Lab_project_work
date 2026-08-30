DO $$
DECLARE loc_id INT;
BEGIN

  -- ==================== СТЕЛЛАЖ, ПОЛКА 1 ====================

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.1','Glutaraldehude solution 50wt%','Глутаровый альдегид 50%','Glutaraldehyde','C5H8O2','111-30-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.2','Poly(allylamine hydrochloride) 50 000','Полиаллиламин гидрохлорид 50 000','PAH 50k',NULL,'71550-12-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.3','(3-Aminopropil)triethoxysilene 99%','(3-Аминопропил)триэтоксисилан 99%','APTES','C9H23NO3Si','919-30-2',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.4','Titanium (IV) butoxide 97%','Титан (IV) бутоксид 97%','Ti(OBu)4','C16H36O4Ti','5593-70-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.5','Натрий гидроокись чда','Натрий гидроокись чда','NaOH','NaOH','1310-73-2',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.6','Sodium dodecil sulfate 99%','Додецилсульфат натрия 99%','SDS','C12H25NaO4S','151-21-3',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.7','Isooctyl acrylate','Изооктилакрилат','IOA','C11H20O2','29590-42-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.8','Тритон Х-100','Тритон Х-100','Triton X-100',NULL,'9002-93-1',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.9','Тритон Х-114','Тритон Х-114','Triton X-114',NULL,'9036-19-5',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.10','Trizma hydrochloride LS','Тризма гидрохлорид','Tris-HCl','C4H12ClNO3','1185-53-1',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.11','Chitin from shrimp shells','Хитин из панцирей креветок','Chitin',NULL,'1398-61-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.12','Магния хлорид 6-водный','Магния хлорид 6-водный','MgCl2·6H2O','Cl2MgO6','7791-18-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.13','Tannic acid','Танниновая кислота','Tannic acid',NULL,'1401-55-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.14','Hydroxylamine solution 50wt%','Гидроксиламин раствор 50%','NH2OH','H3NO','7803-49-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.15','Nonidet P40','Нонидет P40','NP-40',NULL,'9016-45-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.16','Citric acid anhydrous (USP, BP, Ph. Eur., JP)','Лимонная кислота безводная','Citric acid','C6H8O7','77-92-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.17','Potassium Chloride pure','Калий хлористый чистый','KCl','KCl','7447-40-7',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.18','Ammoniumb Acetate pure','Аммония ацетат чистый','NH4OAc','C2H7NO2','631-61-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.19','Pottassium Hydroxide Pellets','Калий гидроксид гранулы','KOH','KOH','1310-58-3',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','1','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '1' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','1.20','Ammonium Sulfate','Аммония сульфат','(NH4)2SO4','(NH4)2SO4','7783-20-2',loc_id,'308');

  -- ==================== СТЕЛЛАЖ, ПОЛКА 2 ====================

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.1','TRIS buffer 1.0M pH 7.5','ТРИС буфер 1.0М pH 7.5','Tris 1M','C4H11NO3','77-86-1',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.2','Agarose Type iv EEO 0.23-0.26','Агароза тип IV EEO 0.23-0.26','Agarose EEO',NULL,'9012-36-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.3','PIPES for buffer solution','ПАЙПС для буферного раствора','PIPES','C8H18N2O6S2','5625-37-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.4','Агароза 100г','Агароза 100г','Agarose',NULL,'9012-36-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.5','Agarose RA 100g','Агароза RA 100г','Agarose RA',NULL,'9012-36-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.6','Sodium chloride 1kg','Натрий хлористый 1кг','NaCl 1kg','NaCl','7647-14-5',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.7','Sodium chloride 500g','Натрий хлористый 500г','NaCl 500g','NaCl','7647-14-5',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.8','Инозин','Инозин','Inosine','C10H12N4O5','58-63-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.9','Ксантин','Ксантин','Xanthine','C5H4N4O2','69-89-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.10','Resazurin sodium salt','Резазурин натриевая соль','Resazurin','C12H6NNaO4S','62758-13-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.11','Трипановый синий','Трипановый синий','Trypan Blue','C34H24N6O14S4','72-57-1',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.12','Agarose standard LS','Агароза стандарт LS','Agarose LS',NULL,'9012-36-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.13','Agarose low EEO','Агароза низкий EEO','Agarose low EEO',NULL,'9012-36-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.14','Agar select','Агар селект','Agar select',NULL,'9002-18-0',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.15','Среда Луриа-Бертани порошок по Миллеру','Среда Луриа-Бертани (Миллер)','LB broth Miller',NULL,NULL,loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.16','Chloramphenicol','Хлорамфеникол','CAM','C11H12Cl2N2O5','56-75-7',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.17','Streptomycin Sulfate','Стрептомицин сульфат','Streptomycin','C42H84N14O36S3','3810-74-0',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.18','TRIS Base','ТРИС основание','Tris','C4H11NO3','77-86-1',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.19','Среда SOB','Среда SOB','SOB medium',NULL,NULL,loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.20','Penicillin G Potassium Salt','Пенициллин G калиевая соль','Pen G K','C16H18KN2O4S','113-98-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.21','Gentamycin Sulfate','Гентамицин сульфат','Gentamicin',NULL,'1405-41-0',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.22','Ethidium Bromide','Бромид этидия','EtBr','C21H20BrN3','1239-45-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.23','MES Free Acid Monohydrate','МЕС свободная кислота моногидрат','MES','C6H13NO4S','145224-94-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.24','MES hydrate','МЕС гидрат','MES·H2O','C6H13NO4S·H2O','1266615-60-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.25','N-Lauroylsarcosine Sodium Salt pure','N-Лауроилсаркозин натриевая соль','Sarkosyl','C15H28NNaO3S','137-16-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.26','Tetracycline hydrochloride','Тетрациклин гидрохлорид','TC-HCl','C22H25ClN2O8','64-75-5',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.27','Ampicoillin Sodium Salt','Ампициллин натриевая соль','Amp','C16H18N3NaO4S','69-52-3',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.28','N-[Tris(Hydroxymethyl)Methyl] 2-Aminoethanesulphonic Acid','N-[Трис(гидроксиметил)метил]-2-аминоэтансульфокислота','TES','C6H15NO6S','7365-44-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.29','HEPES','ХЕПЕС','HEPES','C8H18N2O4S','7365-45-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.30','HEPES for cell culture','ХЕПЕС для клеточных культур','HEPES cell','C8H18N2O4S','7365-45-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.31','MOPS for buffer solution','МОПС для буферного раствора','MOPS','C7H15NO4S','1132-61-2',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.32','TAPS Free Acid','ТАПС свободная кислота','TAPS','C7H17NO6S','29915-38-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.33','TES','ТЕС','TES','C6H15NO6S','7365-44-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.34','Boric Acid for buffer solutions','Борная кислота для буферов','H3BO3','H3BO3','10043-35-3',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.35','Terrific Broth II','Питательная среда Terrific Broth II','TB II',NULL,NULL,loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.36','LB BROTH','Среда Луриа-Бертани','LB',NULL,NULL,loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.37','Магний сернокислый 7-водный для культивирования клеток','Магний сернокислый 7-водный','MgSO4·7H2O','MgO4S·7H2O','10034-99-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.38','Аммоний сернокислый','Аммоний сернокислый','(NH4)2SO4','(NH4)2SO4','7783-20-2',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.39','Марганца 2 хлорид 4-водный для аналитики','Марганца хлорид 4-водный','MnCl2·4H2O','Cl2MnO4','13446-34-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.40','Chloramphenicol','Хлорамфеникол','CAM','C11H12Cl2N2O5','56-75-7',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','2','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '2' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','2.41','ТРИС TRIS (Trometamol) HOPAX High Purity 1 кг','ТРИС (Трометамол) HOPAX 1 кг','Tris HOPAX','C4H11NO3','77-86-1',loc_id,'308');

  -- ==================== СТЕЛЛАЖ, ПОЛКА 3 ====================

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.1','Calcium Chloride dried powdered','Кальций хлористый сухой порошок','CaCl2','CaCl2','10043-52-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.2','Calcium Chloride dihydrate','Кальций хлористый двуводный','CaCl2·2H2O','CaCl2O2','10035-04-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.3','Magnesium chloride 6-hydrate','Магний хлористый 6-водный','MgCl2·6H2O','Cl2MgO6','7791-18-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.4','Sodium carbonate 2.5 kg','Натрий углекислый 2.5 кг','Na2CO3 2.5kg','CNa2O3','497-19-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.5','Poly(sodium 4-styrenesulfonate) 70 000','Полистиролсульфонат натрия 70 000','PSS 70k',NULL,'25704-18-1',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.6','Sodium carbonate 5 kg','Натрий углекислый 5 кг','Na2CO3 5kg','CNa2O3','497-19-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.7','Iron(II) cloride tetrahydrate','Железо(II) хлорид тетрагидрат','FeCl2·4H2O','Cl2FeO4','13478-10-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.8','Mueller-Hinton Agar','Агар Мюллера-Хинтона','MHA',NULL,NULL,loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.9','Giolitti-Cantoni','Среда Джолитти-Кантони','Giolitti-Cantoni',NULL,NULL,loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.10','Listeria PALCAM Agar base','Агар основа PALCAM для листерий','PALCAM',NULL,NULL,loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.11','Iron(III) chloride hexahydrate','Железо(III) хлорид гексагидрат','FeCl3·6H2O','Cl3FeO6','10025-77-1',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.12','Dextran 70','Декстран 70','Dextran 70k',NULL,'9004-54-0',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.13','Sodium Pyruvate for analysis','Натрий пировиноградный для анализа','Na Pyruvate','C3H3NaO3','113-24-6',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.14','Lithium chloride pure','Литий хлористый чистый','LiCl','ClLi','7447-41-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.15','D(+)-Glucose anhydrous for cell culture','D(+)-Глюкоза безводная','Glucose','C6H12O6','50-99-7',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.16','di-Sodium Hydrogen Phosphate anhydrous','Натрий фосфорнокислый двузамещённый','Na2HPO4','HNa2O4P','7558-79-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.17','Imidazole for buffer solution','Имидазол для буферного раствора','Imidazole','C3H4N2','288-32-4',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.18','Gadolinium(III) chloride','Гадолиний(III) хлорид','GdCl3','Cl3Gd','10138-52-0',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.19','Глицерин','Глицерин','Glycerol','C3H8O3','56-81-5',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.20','N,N-Метилен-бисакриламид','N,N-Метилен-бисакриламид','MBA','C7H10N2O2','110-26-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.21','Sodium Hydroxide pellets','Натрий гидроксид гранулы','NaOH','NaOH','1310-73-2',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.22','Sodium dodecil sulfate (SDS)','Додецилсульфат натрия (ДСН)','SDS','C12H25NaO4S','151-21-3',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Стеллаж','3','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Стеллаж' AND shelf IS NOT DISTINCT FROM '3' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','3.23','6-Aminocaproic acid','6-Аминокапроновая кислота','EACA','C6H13NO2','60-32-2',loc_id,'308');

  -- ==================== ХОЛОДИЛЬНИК ====================

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Холодильник',NULL,'-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Холодильник' AND shelf IS NOT DISTINCT FROM NULL AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent',NULL,'PIPES Sesquisodium Salt Buffer extrapure 99%','ПАЙПС полунатриевая соль 99%','PIPES Na','C8H17N2NaO6S2·0.5Na','108321-07-9',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Холодильник',NULL,'-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Холодильник' AND shelf IS NOT DISTINCT FROM NULL AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','Х.1','1-(3-Dimethylaminopropyl)-3-ethylcarbodiimide Hydrochloride','1-(3-ДМАП)-3-этилкарбодиимид гидрохлорид','EDC·HCl','C8H18ClN3','25952-53-8',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Холодильник',NULL,'-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Холодильник' AND shelf IS NOT DISTINCT FROM NULL AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','Х.2','3,3-Dithiobis(sulfosuccinimidylnpropionate) DTSSP 50 mg','3,3-Дитиобис(сульфосукцинимидилпропионат)','DTSSP','C16H18N2O14S4','57444-62-9',loc_id,'308');

  -- ==================== БЕЛЫЙ ШКАФ, ПОЛКА 4 ====================

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Белый шкаф','4','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Белый шкаф' AND shelf IS NOT DISTINCT FROM '4' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','4.12','Terephthalic Acid 500g','Терефталевая кислота 500г','TPA','C8H6O4','100-21-0',loc_id,'308');

  INSERT INTO locations (room,cabinet,shelf,slot) VALUES ('308','Белый шкаф','4','-')
    ON CONFLICT (room,cabinet,shelf,slot) DO NOTHING;
  SELECT id INTO loc_id FROM locations WHERE room='308' AND cabinet='Белый шкаф' AND shelf IS NOT DISTINCT FROM '4' AND slot='-' LIMIT 1;
  INSERT INTO items (item_type,catalog_number,name,name_ru,name_en,formula,cas,location_id,source_sheet)
    VALUES ('reagent','4.13','1,3,5-Benzenetricarboxylic Acid 500g','1,3,5-Бензолтрикарбоновая кислота 500г','Trimesic acid','C9H6O6','554-95-0',loc_id,'308');

END $$;

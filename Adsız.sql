DnUniversite Veritabanı
-- 1) Kitaplar Tablosu
CREATE TABLE IF NOT EXISTS public.kitaplar
(
    id integer NOT NULL,
    ad varchar(50) NOT NULL,
    yazar varchar(30) NOT NULL,
    tarih date NOT NULL,
    CONSTRAINT kitaplar_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.kitaplar OWNER TO postgres;

-- 2) Fakülte Tablosu
CREATE TABLE IF NOT EXISTS public.fakulte
(
    id integer NOT NULL,
    ad varchar(20),
    CONSTRAINT fakulte_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.fakulte OWNER TO postgres;

-- 3) Bölüm Tablosu
CREATE TABLE IF NOT EXISTS public.bolum
(
    bolumid integer NOT NULL,
    bolumad varchar(20) NOT NULL,
    bolumf integer NOT NULL,
    CONSTRAINT bolum_pkey PRIMARY KEY (bolumid),
    CONSTRAINT bolumfakulte_foreign FOREIGN KEY (bolumf)
        REFERENCES public.fakulte (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS fki_bolumfakulte_foreign
    ON public.bolum USING btree (bolumf ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.bolum OWNER TO postgres;

-- 4) Bölüm3 Tablosu
CREATE TABLE IF NOT EXISTS public.bolum3
(
    id integer NOT NULL,
    ad varchar(15) NOT NULL,
    CONSTRAINT bolum3_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.bolum3 OWNER TO postgres;

-- 5) Dersler Tablosu
CREATE TABLE IF NOT EXISTS public.dersler
(
    id integer NOT NULL,
    dersad varchar(15) NOT NULL,
    bolumid integer NOT NULL,
    kontenjan integer,
    CONSTRAINT dersler_pkey PRIMARY KEY (id),
    CONSTRAINT dersler_bolum_fk FOREIGN KEY (bolumid) REFERENCES bolum(bolumid)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.dersler OWNER TO postgres;

Dburun Veritabanı
-- 1) Meslek Tablosu
CREATE TABLE IF NOT EXISTS public.meslek
(
    id integer NOT NULL,
    ad varchar(15) NOT NULL,
    CONSTRAINT meslek_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.meslek OWNER TO postgres;

-- 2) Müşteri Tablosu
CREATE TABLE IF NOT EXISTS public.musteri
(
    id integer NOT NULL,
    ad varchar(15) NOT NULL,
    soyad varchar(10) NOT NULL,
    sehir varchar(20),
    bakiye integer,
    meslek integer,
    CONSTRAINT musteri_pkey PRIMARY KEY (id),
    CONSTRAINT musteri_meslek_fk FOREIGN KEY (meslek) REFERENCES meslek(id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.musteri OWNER TO postgres;

-- 3) Ürün Tablosu
CREATE TABLE IF NOT EXISTS public.urun
(
    id integer NOT NULL,
    ad varchar(30) NOT NULL,
    stok integer,
    kategori varchar(20),
    CONSTRAINT urun_pkey PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.urun OWNER TO postgres;

Örnek SQL Komutları
-- INSERT
INSERT INTO musteri(id, ad, soyad, sehir, bakiye, meslek) 
VALUES (10, 'Nalan', 'Tunç', 'Adana', 2500, 1);

-- SELECT with WHERE
SELECT * FROM musteri WHERE sehir='Ankara' AND id=6 OR sehir='İzmir';
SELECT * FROM musteri WHERE sehir='Ankara' AND bakiye > 2300 AND soyad='Yilmaz';
SELECT * FROM musteri WHERE ad LIKE '%ır%';
SELECT * FROM musteri WHERE ad NOT LIKE '%ır%';

-- UPDATE
UPDATE musteri SET bakiye = 5750 WHERE id = 1;
UPDATE musteri SET sehir = 'İzmir' WHERE id = 2;

-- DELETE
DELETE FROM musteri WHERE id = 10;

-- COUNT / SUM / AVG / MIN / MAX
SELECT COUNT(*) FROM musteri WHERE sehir='Malatya';
SELECT SUM(bakiye) FROM musteri WHERE sehir='Malatya';
SELECT AVG(bakiye) FROM musteri WHERE sehir='Malatya';
SELECT MIN(bakiye) FROM musteri WHERE sehir='Malatya';
SELECT MAX(bakiye) FROM musteri;

-- GROUP BY / HAVING
SELECT sehir, COUNT(*) AS kisi FROM musteri GROUP BY sehir ORDER BY COUNT(*) DESC;
SELECT sehir, AVG(bakiye) AS ortalama FROM musteri GROUP BY sehir HAVING AVG(bakiye) > 5000 OR sehir LIKE '%s%';

-- Alt sorgular
SELECT * FROM musteri WHERE bakiye = (SELECT MAX(bakiye) FROM musteri);
SELECT * FROM musteri WHERE meslek = (SELECT id FROM meslek WHERE ad='öğretmen');
UPDATE musteri SET bakiye = bakiye*1.1 WHERE meslek = (SELECT id FROM meslek WHERE ad='mühendis');

-- TRUNCATE
TRUNCATE TABLE urun;

-- JOIN Örnekleri
-- Inner Join
SELECT m.ad, m.soyad, m.sehir, ms.ad AS meslek_ad
FROM musteri m
INNER JOIN meslek ms ON m.meslek = ms.id;

-- Left Join
SELECT b.bolumid, b.bolumad, f.ad AS fakulte_ad
FROM bolum b
LEFT JOIN fakulte f ON b.bolumf = f.id;

-- Right Join
SELECT b.bolumid, b.bolumad, f.ad AS fakulte_ad
FROM bolum b
RIGHT JOIN fakulte f ON f.id = b.bolumf;

-- Full Join
SELECT m.ad, m.soyad, m.sehir, ms.ad AS meslek_ad
FROM musteri m
FULL JOIN meslek ms ON m.meslek = ms.id;

-- Cross Join
SELECT b.bolumad, f.ad AS fakulte_ad
FROM bolum b
CROSS JOIN fakulte f;

-- Metinsel Fonksiyonlar
SELECT ASCII('F');
SELECT CONCAT('Günaydın ','SQL ','Dersleri');
SELECT CONCAT_WS('*','Günaydın','SQL','Dersleri');
SELECT LEFT('Merhaba Dünya',3);
SELECT RIGHT('Merhaba Dünya',3);
SELECT LENGTH('Benim manevi mirasım bilim ve akıldır');
SELECT LOWER(ad), UPPER(ad) FROM bolum3;

-- Matematiksel Fonksiyonlar
SELECT ABS(-5);
SELECT CEILING(4.85);
SELECT FLOOR(4.85);
SELECT PI();
SELECT POWER(2,4);
SELECT RANDOM();
SELECT ROUND(18.12345,2);
SELECT SIGN(-25);
SELECT SQRT(625);
SELECT LOG(50);

-- Tarih / Zaman Fonksiyonları
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;
SELECT NOW();
SELECT AGE(TIMESTAMP '2025-10-08');
SELECT ad, tarih, AGE(NOW(), tarih) FROM kitaplar;

-- View Örnekleri
CREATE VIEW view1 AS
SELECT b.bolumid, b.bolumad, f.ad AS fakulte_ad, d.dersad, d.kontenjan
FROM bolum b
JOIN fakulte f ON b.bolumf = f.id
JOIN dersler d ON b.bolumid = d.bolumid;

SELECT * FROM view1;

DROP VIEW IF EXISTS view1;

-- With Check Option
-- insert into view2(id, dersad) values (9, 'oop');

-- Değişken Tanımlama ve Kullanma
DO $$
DECLARE 
    x INT := 20,
    y INT := 15,
    z INT;
BEGIN 
    RAISE NOTICE 'Sayı 1: %', x;
    RAISE NOTICE 'Sayı 2: %', y;
    RAISE NOTICE 'Sayı 3: %', z;
END $$;

-- Değişkenler ile Aritmetik İşlemler

DO $$
DECLARE 
    x INT := 20,
    y INT := 5,
    toplam INT,
    fark INT,
    carpim INT,
    bolum INT;
BEGIN 
    toplam := x + y; 
    fark := x - y;
    carpim := x * y;
    bolum := x / y;
    RAISE NOTICE 'Sayı 1: %', x;
    RAISE NOTICE 'Sayı 2: %', y;
    RAISE NOTICE 'Toplam: %', toplam;
    RAISE NOTICE 'Fark: %', fark;
    RAISE NOTICE 'Çarpım: %', carpim;
    RAISE NOTICE 'Bölüm: %', bolum;
END $$;

-- Tablo Değerlerini Değişkenlere Atama
DO $$
DECLARE 
    toplam INT,
    toplam2 INT;
BEGIN 
    toplam := (SELECT COUNT(*) FROM dersler);
    toplam2 := (SELECT COUNT(*) FROM dersler WHERE LENGTH(dersad) > 10);
    RAISE NOTICE 'Derslerin kayıt sayısı: %', toplam;
    RAISE NOTICE 'Ders adı 10 karakterden uzun ders sayısı: %', toplam2;
END $$;

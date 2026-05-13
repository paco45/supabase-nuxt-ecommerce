-- =============================================================
-- ESQUEMA COMPLETO: Tienda Skin Care Colombia
-- Basado en supabase-nuxt-ecommerce + adaptaciones skin care
-- =============================================================

-- -------------------------------------------------------------
-- EXTENSIONES
-- -------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS unaccent;

-- -------------------------------------------------------------
-- ENUMS
-- -------------------------------------------------------------
CREATE TYPE "orderStatus" AS ENUM (
  'Pending', 'Confirmed', 'Processed', 'Shipped', 'Delivered', 'Cancelled'
);

CREATE TYPE "skincareCategory" AS ENUM (
  'Limpiadores', 'Tónicos', 'Sérums', 'Hidratantes',
  'Protección Solar', 'Contorno de Ojos', 'Mascarillas',
  'Exfoliantes', 'Aceites', 'Kits'
);

-- -------------------------------------------------------------
-- TABLA: categories
-- -------------------------------------------------------------
CREATE TABLE categories (
  id               serial PRIMARY KEY,
  name             text NOT NULL,
  slug             text,
  description      text,
  "backgroundImage" text
);

-- -------------------------------------------------------------
-- TABLA: vendors
-- -------------------------------------------------------------
CREATE TABLE vendors (
  id          serial PRIMARY KEY,
  name        text,
  slug        text,
  image       text,
  background  text,
  "createdAt" timestamptz NOT NULL DEFAULT now()
);

-- -------------------------------------------------------------
-- TABLA: products  (con campos skin care)
-- -------------------------------------------------------------
CREATE TABLE products (
  id                  serial PRIMARY KEY,
  name                text NOT NULL,
  slug                text,
  "unitPrice"         numeric(12,2),
  currency            text DEFAULT 'COP',
  description         text,
  "shortDescription"  text,
  "primaryImage"      text,
  "imageUrls"         text[],
  "hoverImage"        text,
  "stockQuantity"     integer NOT NULL DEFAULT 0,
  "inStock"           boolean GENERATED ALWAYS AS ("stockQuantity" > 0) STORED,
  "skincareCategory"  "skincareCategory",
  "primaryCategoryId" integer REFERENCES categories(id),
  "vendorId"          integer REFERENCES vendors(id),
  ingredients         text,
  "howToUse"          text,
  volume              text,
  "skinType"          text[],
  "isFeatured"        boolean NOT NULL DEFAULT false,
  discount            numeric(5,2),
  "createdAt"         timestamptz DEFAULT now(),
  "updatedAt"         timestamptz DEFAULT now()
);

-- -------------------------------------------------------------
-- TABLA: products_categories  (relación N:M)
-- -------------------------------------------------------------
CREATE TABLE products_categories (
  "productId"  integer NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  "categoryId" integer NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  PRIMARY KEY ("productId", "categoryId")
);

-- -------------------------------------------------------------
-- TABLA: profiles  (extiende auth.users de Supabase)
-- -------------------------------------------------------------
CREATE TABLE profiles (
  id         uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  firstname  text,
  lastname   text
);

-- -------------------------------------------------------------
-- TABLA: addresses
-- -------------------------------------------------------------
CREATE TABLE addresses (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"   uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  name       text NOT NULL,
  address    text NOT NULL,
  city       text NOT NULL,
  country    text NOT NULL DEFAULT 'Colombia',
  zipcode    text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- -------------------------------------------------------------
-- TABLA: cart
-- -------------------------------------------------------------
CREATE TABLE cart (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  createdby   uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  currency    text DEFAULT 'COP',
  totalprice  numeric(14,2) DEFAULT 0,
  createdat   timestamptz DEFAULT now(),
  updatedat   timestamptz DEFAULT now()
);

-- -------------------------------------------------------------
-- TABLA: cartItems
-- -------------------------------------------------------------
CREATE TABLE "cartItems" (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "cartId"    uuid REFERENCES cart(id) ON DELETE CASCADE,
  "productId" integer REFERENCES products(id) ON DELETE CASCADE,
  price       numeric(12,2) NOT NULL,
  quantity    integer NOT NULL DEFAULT 1
);

-- -------------------------------------------------------------
-- TABLA: orders  (con campos MercadoPago)
-- -------------------------------------------------------------
CREATE TABLE orders (
  id                    serial PRIMARY KEY,
  "userId"              uuid REFERENCES auth.users(id),
  "addressId"           uuid REFERENCES addresses(id),
  "orderStatus"         "orderStatus" DEFAULT 'Pending',
  "mercadopagoId"       text,
  "mercadopagoStatus"   text,
  "paymentMethod"       text,
  "createdAt"           timestamptz DEFAULT now(),
  "updatedAt"           timestamptz DEFAULT now()
);

-- -------------------------------------------------------------
-- TABLA: orderItems
-- -------------------------------------------------------------
CREATE TABLE "orderItems" (
  id          serial PRIMARY KEY,
  "orderId"   integer REFERENCES orders(id) ON DELETE CASCADE,
  "productId" integer REFERENCES products(id),
  price       numeric(12,2),
  quantity    integer
);

-- -------------------------------------------------------------
-- TABLA: reviews
-- -------------------------------------------------------------
CREATE TABLE reviews (
  id           serial PRIMARY KEY,
  "productId"  integer REFERENCES products(id) ON DELETE CASCADE,
  "userId"     uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  rating       integer CHECK (rating BETWEEN 1 AND 5),
  "reviewText" text,
  timestamp    timestamptz DEFAULT now()
);

-- -------------------------------------------------------------
-- TABLA: wishlist
-- -------------------------------------------------------------
CREATE TABLE wishlist (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id integer NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, product_id)
);

-- -------------------------------------------------------------
-- FUNCIONES AUXILIARES
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION slugify(value text)
RETURNS text AS $$
  SELECT lower(regexp_replace(unaccent(trim(value)), '[^a-z0-9]+', '-', 'gi'));
$$ LANGUAGE sql IMMUTABLE;

CREATE OR REPLACE FUNCTION is_member_of(_user_id uuid, _cart_id uuid)
RETURNS boolean AS $$
  SELECT EXISTS (SELECT 1 FROM cart WHERE id = _cart_id AND createdby = _user_id);
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION search_products_by_name_prefix(prefix text)
RETURNS SETOF products AS $$
  SELECT * FROM products
  WHERE lower(name) LIKE lower(prefix) || '%'
  ORDER BY name;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION get_wishlist_count(user_uuid uuid)
RETURNS bigint AS $$
  SELECT COUNT(*) FROM wishlist WHERE user_id = user_uuid;
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION can_add_to_wishlist(user_uuid uuid)
RETURNS boolean AS $$
  SELECT get_wishlist_count(user_uuid) < 50;
$$ LANGUAGE sql SECURITY DEFINER;

-- -------------------------------------------------------------
-- SEED: 10 categorías de Skin Care
-- -------------------------------------------------------------
INSERT INTO categories (name, slug, description) VALUES
  ('Limpiadores',      'limpiadores',      'Limpia sin resecar. El primer paso de tu rutina.'),
  ('Tónicos',          'tonicos',          'Equilibra y prepara tu piel para absorber mejor los activos.'),
  ('Sérums',           'serums',           'Activos concentrados para cada necesidad de tu piel.'),
  ('Hidratantes',      'hidratantes',      'Hidratación profunda para mantener tu piel suave y luminosa.'),
  ('Protección Solar', 'proteccion-solar', 'Protege tu piel del fotoenvejecimiento todos los días.'),
  ('Contorno de Ojos', 'contorno-ojos',    'Cuida la zona más delicada con fórmulas especializadas.'),
  ('Mascarillas',      'mascarillas',      'Tratamientos intensivos para tu ritual de fin de semana.'),
  ('Exfoliantes',      'exfoliantes',      'Renueva tu piel eliminando células muertas suavemente.'),
  ('Aceites',          'aceites',          'Nutrición y brillo natural con aceites botánicos.'),
  ('Kits',             'kits',             'Rutinas completas a un mejor precio.');

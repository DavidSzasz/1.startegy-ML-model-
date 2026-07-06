CREATE TABLE "dataset_version" (
  "id" int PRIMARY KEY,
  "version_name" varchar(100),
  "dataset_description" text,
  "start_date" date,
  "end_date" date,
  "row_count" int,
  "created_at" timestamp,
  "is_deleted" bool,
  "deleted_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "ML_Model" (
  "id" int PRIMARY KEY,
  "model_name" varchar(100),
  "model_architecture" varchar(100),
  "target" varchar(15),
  "environment_state" "enum(Development,Testing,Staging,Production,Relearning)",
  "created_at" timestamp,
  "is_deleted" bool,
  "deleted_at" timestampe,
  "updated_at" timestamp
);

CREATE TABLE "ml_model_experiments" (
  "id" int PRIMARY KEY,
  "model_version" varchar(100),
  "dataset_version" varchar(100),
  "hyperparameter" text,
  "validation_metric" text,
  "trading_metrics" text,
  "inference_latency_ms" float,
  "ML_Model_id" int,
  "created_at" timestamp,
  "is_deleted" bool,
  "deleted_at" timestampe,
  "updated_at" timestamp
);

CREATE TABLE "features" (
  "id" int PRIMARY KEY,
  "features_name" varchar(100),
  "feature_description" text,
  "ml_model_experiments_id" int,
  "created_at" timestamp,
  "is_deleted" bool,
  "deleted_at" timestampe,
  "updated_at" timestamp
);

CREATE TABLE "hyperparameter" (
  "id" int PRIMARY KEY,
  "ml_model_experiments_id" int,
  "hyperparameter_set_name" varchar(100),
  "n_estimators" int,
  "max_depth" int,
  "min_samples_split" int,
  "subsample" float,
  "learning_rate" float,
  "optimizer" varchar(50),
  "batch_size" int,
  "epochs" int,
  "regularization_penalty" float,
  "random_state" int,
  "created_at" timestamp,
  "is_deleted" bool,
  "deleted_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "validation_metrics" (
  "id" int PRIMARY KEY,
  "validation_metrics_name" varchar(100),
  "ml_model_experiments_id" int,
  "created_at" timestamp,
  "is_deleted" bool,
  "deleted_at" timestampe,
  "updated_at" timestamp
);

CREATE TABLE "trading_metrics" (
  "id" int PRIMARY KEY,
  "trading_metrics_description" text,
  "ml_model_experiments_id" int,
  "created_at" timestamp,
  "is_deleted" bool,
  "deleted_at" timestampe,
  "updated_at" timestamp
);

COMMENT ON COLUMN "dataset_version"."version_name" IS 'Pl. v1.0-2026-07, v2.1-with-RSI';

COMMENT ON COLUMN "dataset_version"."dataset_description" IS 'Milyen indikátorok vagy szűrések vannak benne';

COMMENT ON COLUMN "dataset_version"."start_date" IS 'Az adatbázisban szereplő legelső tőzsdei nap';

COMMENT ON COLUMN "dataset_version"."end_date" IS 'Az adatbázisban szereplő legutolsó tőzsdei nap';

COMMENT ON COLUMN "dataset_version"."row_count" IS 'Hány sorból áll a dataset (kontrollhoz)';

COMMENT ON COLUMN "ML_Model"."model_architecture" IS 'Modell típusa/algoritmusa (pl. XGBoost)';

COMMENT ON COLUMN "ML_Model"."target" IS 'A célváltozó, amit a modell jósol - long/short';

COMMENT ON COLUMN "ML_Model"."environment_state" IS 'A modell aktuális életciklus-állapota (pl. Production, Testing)';

COMMENT ON COLUMN "ml_model_experiments"."model_version" IS 'Modell verziószáma (pl. v2.4.1)';

COMMENT ON COLUMN "ml_model_experiments"."dataset_version" IS 'A tanításhoz használt adatverzió';

COMMENT ON COLUMN "ml_model_experiments"."hyperparameter" IS 'A modell fix beállítási paraméterei (JSON formátum)';

COMMENT ON COLUMN "ml_model_experiments"."validation_metric" IS 'Matematikai statisztikai mutatók (JSON vagy szöveg)';

COMMENT ON COLUMN "ml_model_experiments"."trading_metrics" IS 'Üzleti/kereskedési eredmények (JSON vagy szöveg)';

COMMENT ON COLUMN "ml_model_experiments"."inference_latency_ms" IS 'A modell válaszideje/gyorsasága ezredmásodpercben';

COMMENT ON COLUMN "hyperparameter"."n_estimators" IS 'A döntési fák száma a modellben';

COMMENT ON COLUMN "hyperparameter"."max_depth" IS 'A fák maximális mélysége';

COMMENT ON COLUMN "hyperparameter"."min_samples_split" IS 'A csomópont felosztásához szükséges minimális mintaszám';

COMMENT ON COLUMN "hyperparameter"."subsample" IS 'Az adatok hány százalékát használja egy fához (0.0 - 1.0)';

COMMENT ON COLUMN "hyperparameter"."learning_rate" IS 'Tanulási ráta / lépésköz (pl. 0.01, 0.1)';

COMMENT ON COLUMN "hyperparameter"."optimizer" IS 'Optimalizáló algoritmus neve (pl. adam, sgd)';

COMMENT ON COLUMN "hyperparameter"."batch_size" IS 'Kötegméret a tanítás során';

COMMENT ON COLUMN "hyperparameter"."epochs" IS 'Tanítási iterációk száma';

COMMENT ON COLUMN "hyperparameter"."regularization_penalty" IS 'L1/L2 regulázás mértéke (Alpha/Lambda)';

COMMENT ON COLUMN "hyperparameter"."random_state" IS 'A reprodukálhatóságért felelős seed szám(Mindig ugyan annak a számnak kell lennie )';

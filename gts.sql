PRAGMA foreign_keys = ON;

---------------------------------------------------------
-- Table: GTS
---------------------------------------------------------
CREATE TABLE GTS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    total_subscribers INTEGER NOT NULL CHECK (total_subscribers >= 0),
    total_debtors INTEGER NOT NULL CHECK (total_debtors >= 0),
    total_long_distance_calls INTEGER NOT NULL CHECK (total_long_distance_calls >= 0)
);

---------------------------------------------------------
-- Table: Address
---------------------------------------------------------
CREATE TABLE Address (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    postal_code TEXT NOT NULL,
    district TEXT NOT NULL,
    street TEXT NOT NULL,
    building TEXT NOT NULL,
    apartment TEXT
);

---------------------------------------------------------
-- Table: ATS
---------------------------------------------------------
CREATE TABLE ATS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('городская', 'ведомственная', 'учрежденческая')),
    range_start TEXT NOT NULL,
    range_end TEXT NOT NULL,
    address_id INTEGER NOT NULL,
    gts_id INTEGER NOT NULL,
    FOREIGN KEY (address_id) REFERENCES Address(id),
    FOREIGN KEY (gts_id) REFERENCES GTS(id)
);

---------------------------------------------------------
-- Table: Subscriber
---------------------------------------------------------
CREATE TABLE Subscriber (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    middle_name TEXT,
    gender TEXT NOT NULL CHECK (gender IN ('м', 'ж')),
    birth_date DATE NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('обычный', 'льготный')),
    has_long_distance_access BOOLEAN NOT NULL CHECK (has_long_distance_access IN (0,1)),
    status TEXT NOT NULL CHECK (status IN ('включен', 'отключен')),
    debt_amount DECIMAL NOT NULL CHECK (debt_amount >= 0),
    ats_id INTEGER NOT NULL,
    FOREIGN KEY (ats_id) REFERENCES ATS(id)
);

---------------------------------------------------------
-- Table: Phone
---------------------------------------------------------
CREATE TABLE Phone (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    number TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('основной', 'параллельный', 'спаренный')),
    status TEXT NOT NULL CHECK (status IN ('свободен', 'занят', 'отключен')),
    address_id INTEGER NOT NULL,
    ats_id INTEGER NOT NULL,
    FOREIGN KEY (address_id) REFERENCES Address(id),
    FOREIGN KEY (ats_id) REFERENCES ATS(id)
);

---------------------------------------------------------
-- Table: Payment
---------------------------------------------------------
CREATE TABLE Payment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subscriber_id INTEGER NOT NULL,
    payment_date DATE NOT NULL,
    month TEXT NOT NULL,
    amount DECIMAL NOT NULL CHECK (amount >= 0),
    payment_type TEXT NOT NULL CHECK (payment_type IN ('абонплата', 'межгород', 'пени', 'подключение')),
    status TEXT NOT NULL CHECK (status IN ('оплачено', 'просрочено')),
    FOREIGN KEY (subscriber_id) REFERENCES Subscriber(id)
);

---------------------------------------------------------
-- Table: LongDistanceCall
---------------------------------------------------------
CREATE TABLE LongDistanceCall (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subscriber_id INTEGER NOT NULL,
    call_datetime DATETIME NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes >= 0),
    cost DECIMAL NOT NULL CHECK (cost >= 0),
    payment_status TEXT NOT NULL CHECK (payment_status IN ('оплачено', 'не оплачено')),
    FOREIGN KEY (subscriber_id) REFERENCES Subscriber(id)
);

---------------------------------------------------------
-- Table: Queue
---------------------------------------------------------
CREATE TABLE Queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subscriber_id INTEGER NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('обычная', 'льготная')),
    request_date DATE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('ожидание', 'рассмотрено', 'установлено')),
    FOREIGN KEY (subscriber_id) REFERENCES Subscriber(id)
);

---------------------------------------------------------
-- Table: Payphone
---------------------------------------------------------
CREATE TABLE Payphone (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone_number TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('таксофон', 'общественный')),
    address_id INTEGER NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('действует', 'не работает')),
    FOREIGN KEY (address_id) REFERENCES Address(id)
);

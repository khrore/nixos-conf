# CLAUDE.md - Software Development Standards

## Meta
- **Purpose**: Guide AI assistants and developers in architectural decisions and code quality
- **Primary Language**: Rust (principles apply to TypeScript, Go, and other statically-typed languages)
- **Philosophy**: Make illegal states unrepresentable. Type safety > Runtime checks > Tests > Documentation
- **Last Updated**: 2026-01-20

---

## Table of Contents
1. [Core Principles](#core-principles)
2. [Type-Driven Design](#type-driven-design)
3. [Mandatory Patterns](#mandatory-patterns)
4. [SOLID Principles](#solid-principles)
5. [Pattern Catalog](#pattern-catalog)
6. [Decision Framework](#decision-framework)
7. [Anti-Patterns](#anti-patterns)
8. [Code Review Checklist](#code-review-checklist)
9. [Complete Examples](#complete-examples)

---

## Core Principles

### Priority Hierarchy

#### Tier 1: Correctness & Type Safety
1. **Type-Driven Design** - Types are the primary documentation and enforcement mechanism
2. **Make Illegal States Unrepresentable** - Use the type system to prevent errors at compile time
3. **Explicit Over Implicit** - No silent failures, no hidden behaviors

#### Tier 2: Simplicity
1. **YAGNI** (You Aren't Gonna Need It) - Don't build for hypothetical future requirements
2. **KISS** (Keep It Simple, Stupid) - Simple solutions > Clever solutions
3. **Rule of Three** - Don't abstract until the 3rd use case

#### Tier 3: Maintainability
1. **SOLID Principles** - Foundation for maintainable architectures
2. **DRY** (Don't Repeat Yourself) - But NOT at the cost of coupling
3. **RAII** (Resource Acquisition Is Initialization) - Lifetime = Scope

### Golden Rules for AI Assistants

**ALWAYS:**
- Use Newtype pattern for domain primitives (IDs, emails, money, etc.)
- Encode state machines in types (Typestate pattern)
- Depend on abstractions, not concrete types (Dependency Inversion)
- Use RAII for resource management
- Return typed errors, never String or generic errors
- Make functions do one thing (Single Responsibility)

**NEVER:**
- Use primitive types for domain concepts ("stringly-typed" code)
- Use boolean parameters for domain concepts (use enums)
- Create abstractions before the 3rd use
- Use `.unwrap()` in library/application code (only in examples/tests)
- Silently ignore errors
- Create "god objects" or "god functions"

---

## Type-Driven Design

### Philosophy

> "If it compiles, it works" should be the goal. Use the compiler as your primary bug-finding tool.

### Process

#### Step 1: Model the Domain in Types

```rust
// ❌ BAD: Primitive obsession
fn create_user(email: String, age: i32, role: String) -> Result<User, String>

// ✅ GOOD: Domain types encode invariants
struct Email(String);
struct Age(u8);  // Can't be negative, can't exceed 255

enum Role {
    Admin,
    Moderator,
    User,
}

impl Email {
    /// Email is ALWAYS valid if this type exists
    fn new(s: String) -> Result<Self, ValidationError> {
        if !s.contains('@') {
            return Err(ValidationError::InvalidEmail);
        }
        Ok(Email(s))
    }
}

impl Age {
    fn new(value: u8) -> Result<Self, ValidationError> {
        if value < 13 {
            return Err(ValidationError::TooYoung);
        }
        Ok(Age(value))
    }
}

// Now this function CANNOT fail - validation happened at construction
fn create_user(email: Email, age: Age, role: Role) -> User {
    User { email, age, role }
}
```

#### Step 2: Use Enums Over Booleans

```rust
// ❌ BAD: Boolean blindness
fn process_payment(
    amount: f64,
    is_recurring: bool,
    is_final: bool,
    is_test: bool,
) -> Result<()>

// What does `process_payment(100.0, true, false, true)` mean?

// ✅ GOOD: Self-documenting types
enum PaymentType {
    OneTime,
    Recurring { interval: Duration },
}

enum PaymentStage {
    Initial,
    Final,
}

enum Environment {
    Production,
    Test,
}

fn process_payment(
    amount: Money,
    payment_type: PaymentType,
    stage: PaymentStage,
    env: Environment,
) -> Result<PaymentResult, PaymentError>
```

#### Step 3: Make Illegal States Unrepresentable

```rust
// ❌ BAD: Can represent invalid states
struct ShoppingCart {
    items: Vec<CartItem>,
    checked_out: bool,  // What if items is empty but checked_out is true?
}

// ✅ GOOD: Invalid states are impossible
enum ShoppingCart {
    Empty,
    Active {
        items: NonEmptyVec<CartItem>,
    },
    CheckedOut {
        order_id: OrderId,
        items: NonEmptyVec<CartItem>,
    },
}

impl ShoppingCart {
    fn checkout(self) -> Result<ShoppingCart, CheckoutError> {
        match self {
            ShoppingCart::Empty => Err(CheckoutError::EmptyCart),
            ShoppingCart::Active { items } => {
                let order_id = create_order(&items)?;
                Ok(ShoppingCart::CheckedOut { order_id, items })
            }
            ShoppingCart::CheckedOut { .. } => Err(CheckoutError::AlreadyCheckedOut),
        }
    }
}
```

#### Step 4: Use Phantom Types for State Machines

```rust
use std::marker::PhantomData;

// State types
struct Draft;
struct Validated;
struct Published;

struct BlogPost<State> {
    title: String,
    content: String,
    _state: PhantomData<State>,
}

// Only Draft posts can be edited
impl BlogPost<Draft> {
    fn new(title: String) -> Self {
        BlogPost {
            title,
            content: String::new(),
            _state: PhantomData,
        }
    }

    fn edit_content(mut self, content: String) -> Self {
        self.content = content;
        self
    }

    fn validate(self) -> Result<BlogPost<Validated>, ValidationError> {
        if self.content.is_empty() {
            return Err(ValidationError::EmptyContent);
        }
        Ok(BlogPost {
            title: self.title,
            content: self.content,
            _state: PhantomData,
        })
    }
}

// Only Validated posts can be published
impl BlogPost<Validated> {
    fn publish(self) -> BlogPost<Published> {
        BlogPost {
            title: self.title,
            content: self.content,
            _state: PhantomData,
        }
    }
}

// Only Published posts can be viewed
impl BlogPost<Published> {
    fn get_content(&self) -> &str {
        &self.content
    }
}
```

---

## Mandatory Patterns

### 1. Newtype Pattern

**ALWAYS use for domain primitives.**

```rust
// ❌ NEVER do this
fn transfer_money(from_user: i64, to_user: i64, amount: f64) -> Result<()>
// What if we accidentally swap from_user and amount? Compiles fine, wrong at runtime!

// ✅ ALWAYS do this
struct UserId(Uuid);
struct Money(Decimal);  // Never use f64 for money!

fn transfer_money(from: UserId, to: UserId, amount: Money) -> Result<(), TransferError>
// Can't accidentally swap parameters - type system prevents it
```

**Benefits:**
- Prevents mixing incompatible values (can't use ProductId where UserId is expected)
- Self-documenting code
- Can add domain-specific methods
- Zero runtime cost (zero-sized wrapper)

**When to use:**
- IDs (UserId, OrderId, ProductId, etc.)
- Email addresses
- Phone numbers
- Money/currency values
- Dates/timestamps with specific meanings
- URLs
- Any domain concept with validation rules

```rust
struct Email(String);
struct OrderId(Uuid);
struct Money(Decimal);
struct Latitude(f64);
struct Longitude(f64);

impl Latitude {
    fn new(value: f64) -> Result<Self, ValidationError> {
        if !(-90.0..=90.0).contains(&value) {
            return Err(ValidationError::InvalidLatitude);
        }
        Ok(Latitude(value))
    }
}

// Now this function signature is clear and type-safe
fn find_nearby_stores(lat: Latitude, lon: Longitude, radius: Meters) -> Vec<Store>
```

### 2. Typestate Pattern

**Use when objects have distinct lifecycle states with different valid operations.**

```rust
struct Connection<State> {
    socket: TcpStream,
    _state: PhantomData<State>,
}

struct Disconnected;
struct Connected;
struct Authenticated;

impl Connection<Disconnected> {
    fn connect(address: &str) -> Result<Connection<Connected>, ConnectionError> {
        let socket = TcpStream::connect(address)?;
        Ok(Connection {
            socket,
            _state: PhantomData,
        })
    }
}

impl Connection<Connected> {
    fn authenticate(self, credentials: Credentials) -> Result<Connection<Authenticated>, AuthError> {
        // Send authentication
        // ...
        Ok(Connection {
            socket: self.socket,
            _state: PhantomData,
        })
    }
}

impl Connection<Authenticated> {
    fn send_message(&mut self, message: &str) -> Result<(), SendError> {
        // Only authenticated connections can send messages
        // ...
        Ok(())
    }
}
```

**When to use:**
- Object lifecycle has distinct states (Draft → Validated → Published)
- Different states have different valid operations
- State transitions have business rules
- You want compile-time guarantees about state

**When NOT to use:**
- States share >80% of methods (use enum instead)
- State is only used for conditional logic (use enum)
- Only 2 states and they're simple (use Option or Result)

### 3. RAII Pattern

**ALWAYS use for resource management. Lifetime = Scope.**

```rust
// ✅ RAII ensures cleanup happens automatically
struct DatabaseConnection {
    conn: Connection,
}

impl Drop for DatabaseConnection {
    fn drop(&mut self) {
        // Connection is ALWAYS closed when it goes out of scope
        self.conn.close();
    }
}

struct FileLock {
    path: PathBuf,
}

impl Drop for FileLock {
    fn drop(&mut self) {
        // Lock is ALWAYS released, even if panic occurs
        std::fs::remove_file(&self.path).ok();
    }
}

// Usage - no manual cleanup needed
fn process_data() -> Result<()> {
    let _lock = FileLock::acquire("data.lock")?;
    let db = DatabaseConnection::connect("localhost")?;

    // Do work...

    // Lock and connection automatically cleaned up here
    Ok(())
} // Drop called here, even if there's a panic or early return
```

**When to use:**
- Database connections
- File handles
- Network sockets
- Locks (mutexes, file locks)
- Temporary files
- Any resource that needs cleanup

### 4. Builder Pattern

**Use when constructing complex objects with validation.**

```rust
// When you have 4+ parameters or complex validation, use Builder + Typestate

struct UserBuilder<State> {
    email: Option<Email>,
    username: Option<String>,
    age: Option<Age>,
    _state: PhantomData<State>,
}

struct Incomplete;
struct Complete;

impl UserBuilder<Incomplete> {
    fn new() -> Self {
        UserBuilder {
            email: None,
            username: None,
            age: None,
            _state: PhantomData,
        }
    }

    fn email(mut self, email: Email) -> Self {
        self.email = Some(email);
        self
    }

    fn username(mut self, username: String) -> Self {
        self.username = Some(username);
        self
    }

    fn age(mut self, age: Age) -> Result<UserBuilder<Complete>, ValidationError> {
        if self.email.is_none() || self.username.is_none() {
            return Err(ValidationError::MissingFields);
        }

        Ok(UserBuilder {
            email: self.email,
            username: self.username,
            age: Some(age),
            _state: PhantomData,
        })
    }
}

impl UserBuilder<Complete> {
    fn build(self) -> User {
        User {
            email: self.email.unwrap(),
            username: self.username.unwrap(),
            age: self.age.unwrap(),
        }
    }
}

// Usage
let user = User::builder()
    .email(email)
    .username("john_doe".to_string())
    .age(age)?
    .build();
```

**When to use:**
- 4+ constructor parameters
- Complex validation that depends on multiple fields
- Optional parameters with defaults
- Immutable result objects

**When NOT to use:**
- Simple construction (1-3 required params) - use `new()`
- Mutable objects that can be configured after creation

---

## SOLID Principles

### S - Single Responsibility Principle

**Each module/struct should have one reason to change.**

```rust
// ❌ BAD: God object with multiple responsibilities
struct UserService {
    db: Database,
    email_client: EmailClient,
    analytics: Analytics,
}

impl UserService {
    fn create_user(&self, data: UserData) -> Result<User> {
        // Database logic
        let user = self.db.insert_user(data)?;

        // Email logic
        self.email_client.send_welcome_email(&user.email)?;

        // Analytics logic
        self.analytics.track_event("user_created", &user.id)?;

        Ok(user)
    }
}

// ✅ GOOD: Separated concerns
struct UserRepository {
    db: Database,
}

impl UserRepository {
    fn save(&self, user: User) -> Result<UserId> {
        self.db.insert_user(user)
    }

    fn find_by_id(&self, id: UserId) -> Result<Option<User>> {
        self.db.query_user(id)
    }
}

struct EmailService {
    client: EmailClient,
}

impl EmailService {
    fn send_welcome_email(&self, email: &Email) -> Result<()> {
        self.client.send(email, WelcomeTemplate::default())
    }
}

struct AnalyticsService {
    tracker: Analytics,
}

impl AnalyticsService {
    fn track_user_created(&self, user_id: UserId) -> Result<()> {
        self.tracker.track("user_created", user_id)
    }
}

// Orchestrator composes the services
struct UserCreationService {
    repository: UserRepository,
    email_service: EmailService,
    analytics: AnalyticsService,
}

impl UserCreationService {
    fn create_user(&self, data: UserData) -> Result<User> {
        let user = User::from(data);
        let user_id = self.repository.save(user)?;

        // Fire and forget side effects (could be async or queued)
        let _ = self.email_service.send_welcome_email(&user.email);
        let _ = self.analytics.track_user_created(user_id);

        Ok(user)
    }
}
```

### O - Open/Closed Principle

**Open for extension, closed for modification.**

```rust
// ✅ Use traits to allow extension without modification
trait PaymentProcessor {
    fn process(&self, amount: Money) -> Result<PaymentResult, PaymentError>;
}

struct StripeProcessor {
    api_key: String,
}

impl PaymentProcessor for StripeProcessor {
    fn process(&self, amount: Money) -> Result<PaymentResult, PaymentError> {
        // Stripe-specific implementation
        Ok(PaymentResult::Success)
    }
}

struct PayPalProcessor {
    client_id: String,
}

impl PaymentProcessor for PayPalProcessor {
    fn process(&self, amount: Money) -> Result<PaymentResult, PaymentError> {
        // PayPal-specific implementation
        Ok(PaymentResult::Success)
    }
}

// Service doesn't need to change when new processors are added
struct PaymentService<P: PaymentProcessor> {
    processor: P,
}

impl<P: PaymentProcessor> PaymentService<P> {
    fn charge(&self, amount: Money) -> Result<PaymentResult, PaymentError> {
        self.processor.process(amount)
    }
}
```

### L - Liskov Substitution Principle

**Subtypes must be substitutable for their base types.**

```rust
// ✅ All implementations honor the trait contract
trait Cache {
    /// Returns None if key doesn't exist
    fn get(&self, key: &str) -> Option<String>;

    /// Stores value, returns previous value if exists
    fn set(&mut self, key: String, value: String) -> Option<String>;
}

struct MemoryCache {
    data: HashMap<String, String>,
}

impl Cache for MemoryCache {
    fn get(&self, key: &str) -> Option<String> {
        self.data.get(key).cloned()
    }

    fn set(&mut self, key: String, value: String) -> Option<String> {
        self.data.insert(key, value)
    }
}

struct RedisCache {
    client: redis::Client,
}

impl Cache for RedisCache {
    fn get(&self, key: &str) -> Option<String> {
        self.client.get(key).ok()
    }

    fn set(&mut self, key: String, value: String) -> Option<String> {
        let prev = self.get(&key);
        self.client.set(key, value).ok()?;
        prev
    }
}

// Any Cache implementation can be used interchangeably
fn use_cache<C: Cache>(cache: &mut C) {
    cache.set("key".to_string(), "value".to_string());
    assert_eq!(cache.get("key"), Some("value".to_string()));
}
```

### I - Interface Segregation Principle

**Many specific interfaces > one general-purpose interface.**

```rust
// ❌ BAD: Fat interface
trait DataStore {
    fn read(&self, key: &str) -> Result<String>;
    fn write(&mut self, key: String, value: String) -> Result<()>;
    fn delete(&mut self, key: &str) -> Result<()>;
    fn list_keys(&self) -> Result<Vec<String>>;
    fn backup(&self) -> Result<()>;
    fn restore(&self, backup: Backup) -> Result<()>;
}

// Some implementations don't support all operations!
// ReadOnlyCache can't implement write/delete/backup/restore

// ✅ GOOD: Segregated interfaces
trait Readable {
    fn read(&self, key: &str) -> Result<String>;
}

trait Writable {
    fn write(&mut self, key: String, value: String) -> Result<()>;
}

trait Deletable {
    fn delete(&mut self, key: &str) -> Result<()>;
}

trait Listable {
    fn list_keys(&self) -> Result<Vec<String>>;
}

trait Backupable {
    fn backup(&self) -> Result<()>;
    fn restore(&self, backup: Backup) -> Result<()>;
}

// Now implementations can pick what they support
struct ReadOnlyCache;

impl Readable for ReadOnlyCache {
    fn read(&self, key: &str) -> Result<String> {
        // Implementation
        Ok(String::new())
    }
}

struct FullFeaturedStore;

impl Readable for FullFeaturedStore { /* ... */ }
impl Writable for FullFeaturedStore { /* ... */ }
impl Deletable for FullFeaturedStore { /* ... */ }
impl Listable for FullFeaturedStore { /* ... */ }
impl Backupable for FullFeaturedStore { /* ... */ }

// Consumers specify exactly what they need
fn read_data<R: Readable>(store: &R, key: &str) -> Result<String> {
    store.read(key)
}

fn sync_data<R: Readable + Writable>(from: &R, to: &mut R, key: &str) -> Result<()> {
    let value = from.read(key)?;
    to.write(key.to_string(), value)?;
    Ok(())
}
```

### D - Dependency Inversion Principle

**Depend on abstractions, not concretions.**

```rust
// ❌ BAD: High-level module depends on low-level module
struct OrderService {
    postgres_db: PostgresDatabase,  // Concrete dependency
}

impl OrderService {
    fn create_order(&self, order: Order) -> Result<OrderId> {
        self.postgres_db.insert_order(order)  // Tightly coupled to Postgres
    }
}

// ✅ GOOD: Both depend on abstraction
trait OrderRepository {
    fn save(&self, order: Order) -> Result<OrderId>;
    fn find_by_id(&self, id: OrderId) -> Result<Option<Order>>;
}

// Low-level module implements abstraction
struct PostgresOrderRepository {
    pool: PgPool,
}

impl OrderRepository for PostgresOrderRepository {
    fn save(&self, order: Order) -> Result<OrderId> {
        // Postgres-specific implementation
        Ok(OrderId::new())
    }

    fn find_by_id(&self, id: OrderId) -> Result<Option<Order>> {
        // Postgres-specific implementation
        Ok(None)
    }
}

// High-level module depends on abstraction
struct OrderService<R: OrderRepository> {
    repository: R,  // Can be ANY OrderRepository
}

impl<R: OrderRepository> OrderService<R> {
    fn create_order(&self, order: Order) -> Result<OrderId> {
        self.repository.save(order)
    }

    fn get_order(&self, id: OrderId) -> Result<Option<Order>> {
        self.repository.find_by_id(id)
    }
}

// Easy to test with mock repository
struct MockOrderRepository {
    orders: HashMap<OrderId, Order>,
}

impl OrderRepository for MockOrderRepository {
    fn save(&self, order: Order) -> Result<OrderId> {
        // Mock implementation
        Ok(OrderId::new())
    }

    fn find_by_id(&self, id: OrderId) -> Result<Option<Order>> {
        Ok(self.orders.get(&id).cloned())
    }
}
```

---

## Pattern Catalog

### When to Use Which Pattern

#### For Domain Modeling
| Pattern | Use When | Example |
|---------|----------|---------|
| **Newtype** | Any domain primitive | `struct Email(String)` |
| **Enum** | Fixed set of variants | `enum Role { Admin, User }` |
| **Typestate** | Object has lifecycle states | `Request<Draft>` → `Request<Sent>` |

#### For Abstraction
| Pattern | Use When | Example |
|---------|----------|---------|
| **Trait** | Define behavior contract | `trait Repository { fn save(&self); }` |
| **Trait Object** | Runtime polymorphism | `Box<dyn Processor>` |
| **Generics** | Compile-time polymorphism | `fn process<T: Processor>(t: T)` |

#### For Construction
| Pattern | Use When | Example |
|---------|----------|---------|
| **new()** | 1-3 required params | `User::new(email, name)` |
| **Builder** | 4+ params or validation | `User::builder().email(e).build()` |
| **Factory** | Complex creation logic | `ConnectionFactory::create(config)` |

#### For Iteration
| Pattern | Use When | Example |
|---------|----------|---------|
| **Iterator** | Lazy sequence processing | `impl Iterator for MyCollection` |
| **IntoIterator** | Convert to iterator | `impl IntoIterator for MyCollection` |

### Factory Pattern

**Use when creation logic is complex or runtime-dependent.**

```rust
enum DatabaseType {
    Postgres,
    Sqlite,
    InMemory,
}

struct DatabaseConfig {
    db_type: DatabaseType,
    connection_string: String,
}

trait Database {
    fn query(&self, sql: &str) -> Result<Vec<Row>>;
}

struct DatabaseFactory;

impl DatabaseFactory {
    fn create(config: DatabaseConfig) -> Result<Box<dyn Database>, DbError> {
        match config.db_type {
            DatabaseType::Postgres => {
                Ok(Box::new(PostgresDb::connect(&config.connection_string)?))
            }
            DatabaseType::Sqlite => {
                Ok(Box::new(SqliteDb::open(&config.connection_string)?))
            }
            DatabaseType::InMemory => {
                Ok(Box::new(InMemoryDb::new()))
            }
        }
    }
}
```

**When to use:**
- Creation depends on runtime configuration
- Multiple implementations behind single interface
- Construction logic is complex (>5 lines)

**When NOT to use:**
- Simple construction - use `new()` or builder
- Only one implementation exists

### Iterator Pattern

**Always implement Iterator for custom collections.**

```rust
struct Fibonacci {
    current: u64,
    next: u64,
}

impl Fibonacci {
    fn new() -> Self {
        Fibonacci { current: 0, next: 1 }
    }
}

impl Iterator for Fibonacci {
    type Item = u64;

    fn next(&mut self) -> Option<Self::Item> {
        let current = self.current;
        self.current = self.next;
        self.next = current + self.next;
        Some(current)
    }
}

// Usage - gets all iterator combinators for free
let sum: u64 = Fibonacci::new()
    .take(10)
    .filter(|x| x % 2 == 0)
    .sum();
```

---

## Decision Framework

### Pattern Selection Flowchart

```
Is this a domain concept (email, ID, money)?
├─ YES → Use Newtype pattern
└─ NO  → Continue

Does it have multiple states with different valid operations?
├─ YES → Use Typestate pattern
└─ NO  → Continue

Are you constructing a complex object?
├─ Simple (1-3 params) → Use new()
├─ Complex (4+ params or validation) → Use Builder pattern
└─ Runtime-dependent → Use Factory pattern

Do you need polymorphism?
├─ Known types at compile time → Use Enum
├─ Plugin system / unknown types → Use Trait + trait objects
└─ Performance critical → Use Generics

Are you managing resources?
└─ Always use RAII (implement Drop)

Are you iterating over a collection?
└─ Implement Iterator trait
```

### Abstraction Decision Tree

**Before creating ANY abstraction, answer these questions:**

1. **Is this used in 3+ places?** (Rule of Three)
   - NO → Don't abstract yet, copy-paste is fine
   - YES → Continue

2. **Are the use cases truly similar?**
   - NO → Don't abstract, keep separate implementations
   - YES → Continue

3. **Does abstraction simplify or complicate?**
   - Complicates → Don't abstract
   - Simplifies → Continue

4. **Can you explain it in one sentence?**
   - NO → Too complex, don't abstract
   - YES → Safe to abstract

**Example:**

```rust
// First use
fn validate_email(email: &str) -> bool {
    email.contains('@')
}

// Second use - similar but different
fn validate_username(username: &str) -> bool {
    username.len() >= 3
}

// STOP! Only 2 uses, and they're different
// Don't create a generic `validate_string()` abstraction yet

// Third use - now we see a pattern
fn validate_password(password: &str) -> bool {
    password.len() >= 8
}

// NOW we can abstract if it truly simplifies
trait Validator {
    fn validate(&self, input: &str) -> bool;
}
```

---

## Anti-Patterns

### 1. Stringly-Typed Programming

```rust
// ❌ NEVER: String IDs, roles, states
fn get_user(id: String) -> User { }
fn has_permission(role: &str) -> bool { }
fn process_order(status: &str) -> Result<()> { }

// ✅ ALWAYS: Type-safe domain concepts
fn get_user(id: UserId) -> User { }
fn has_permission(role: Role) -> bool { }
fn process_order(status: OrderStatus) -> Result<()> { }
```

### 2. Boolean Blindness

```rust
// ❌ NEVER: Boolean parameters
fn send_email(to: Email, urgent: bool, retry: bool) -> Result<()>

// What does send_email(addr, true, false) mean?

// ✅ ALWAYS: Named types
enum Priority { Normal, Urgent }
enum RetryPolicy { NoRetry, Retry }

fn send_email(to: Email, priority: Priority, retry: RetryPolicy) -> Result<()>

// Now it's clear: send_email(addr, Priority::Urgent, RetryPolicy::NoRetry)
```

### 3. Primitive Obsession

```rust
// ❌ NEVER: Using primitives for domain concepts
struct Order {
    user_id: i64,
    product_id: i64,
    price: f64,  // NEVER use f64 for money!
    created_at: i64,  // Unix timestamp - what timezone?
}

// ✅ ALWAYS: Domain types
struct Order {
    user_id: UserId,
    product_id: ProductId,
    price: Money,
    created_at: UtcDateTime,
}
```

### 4. Error Swallowing

```rust
// ❌ NEVER: Silent failures
fn load_config() -> Config {
    let file = std::fs::read_to_string("config.json").ok()?;
    serde_json::from_str(&file).unwrap_or_default()  // Hides errors!
}

// ✅ ALWAYS: Explicit error handling
fn load_config() -> Result<Config, ConfigError> {
    let file = std::fs::read_to_string("config.json")
        .map_err(|e| ConfigError::FileReadError(e))?;

    serde_json::from_str(&file)
        .map_err(|e| ConfigError::ParseError(e))
}
```

### 5. God Objects

```rust
// ❌ NEVER: One object does everything
struct ApplicationService {
    db: Database,
    cache: Cache,
    email: EmailClient,
    storage: S3Client,
    analytics: Analytics,
    // ... 20 more fields
}

impl ApplicationService {
    fn do_everything(&self) { /* 500 lines */ }
}

// ✅ ALWAYS: Single responsibility
struct UserService {
    repository: UserRepository,
}

struct EmailService {
    client: EmailClient,
}

struct StorageService {
    client: S3Client,
}
```

### 6. Premature Abstraction

```rust
// ❌ NEVER: Abstract on first use
fn calculate_total(items: &[Item]) -> Money {
    items.iter().map(|i| i.price).sum()
}

// Don't immediately create:
trait TotalCalculator<T> {
    fn calculate(&self, items: &[T]) -> Money;
}
// Wait for 3rd similar use case!

// ✅ ALWAYS: Wait for Rule of Three
// Copy-paste twice, then abstract on 3rd use
```

### 7. Option/Result Hell

```rust
// ❌ NEVER: Nested confusion
fn get_user_email() -> Option<Result<Option<Email>, Error>> {
    // What does None mean? What about Ok(None)?
}

// ✅ ALWAYS: Flatten with custom types
enum UserEmailLookup {
    Found(Email),
    UserNotFound,
    EmailNotSet,
    DatabaseError(Error),
}

fn get_user_email() -> UserEmailLookup {
    // Clear, exhaustive matching
}
```

---

## Code Review Checklist

### Type Safety ✅

- [ ] **Newtype for ALL domain primitives** (IDs, emails, money, etc.)
- [ ] **No String/i64/f64 for domain concepts**
- [ ] **Enums instead of booleans** for domain states
- [ ] **Typestate for objects with lifecycle**
- [ ] **Invalid states are unrepresentable**

### SOLID Compliance ✅

- [ ] **Each struct/module has ONE responsibility**
- [ ] **Dependencies are on traits, not concrete types**
- [ ] **Traits are specific, not fat interfaces**
- [ ] **No god objects or god functions**
- [ ] **Subtypes honor trait contracts** (Liskov)

### Error Handling ✅

- [ ] **All errors are typed** (no `String` errors)
- [ ] **Results propagated with context** (`.map_err()`)
- [ ] **No `.unwrap()` in library/application code**
- [ ] **`panic!` only for programming errors**, not expected failures
- [ ] **Errors are recoverable or explicitly terminal**

### Simplicity (YAGNI/KISS) ✅

- [ ] **No speculative features** ("we might need this later")
- [ ] **No abstraction before 3rd use** (Rule of Three)
- [ ] **Solution is straightforward**, not clever
- [ ] **No premature optimization**
- [ ] **Code is self-documenting** (types tell the story)

### Resource Management ✅

- [ ] **All resources use RAII** (implement Drop)
- [ ] **No manual cleanup required**
- [ ] **Lifetimes are clear and minimal**
- [ ] **No leaked resources on panic**

### Testing ✅

- [ ] **Types make impossible tests unnecessary**
- [ ] **Tests focus on business logic**, not type mechanics
- [ ] **Property-based tests for algorithms**
- [ ] **Integration tests for workflows**

### Documentation ✅

- [ ] **Public APIs have doc comments**
- [ ] **Types are self-documenting** (good names)
- [ ] **Invariants are documented**
- [ ] **Examples for non-obvious usage**

---

## Complete Examples

### Example 1: E-Commerce Order System

```rust
use std::marker::PhantomData;
use rust_decimal::Decimal;
use uuid::Uuid;

// ===== Domain Types (Newtype Pattern) =====

struct OrderId(Uuid);
struct ProductId(Uuid);
struct UserId(Uuid);
struct Quantity(u32);
struct Money(Decimal);

impl Money {
    fn new(amount: Decimal) -> Result<Self, ValidationError> {
        if amount < Decimal::ZERO {
            return Err(ValidationError::NegativeAmount);
        }
        Ok(Money(amount))
    }

    fn add(&self, other: &Money) -> Money {
        Money(self.0 + other.0)
    }
}

// ===== Order State Types (Typestate Pattern) =====

struct Draft;
struct Validated;
struct Paid;
struct Shipped;
struct Completed;

// ===== Order Entity =====

struct Order<State> {
    id: OrderId,
    user_id: UserId,
    items: Vec<OrderItem>,
    total: Money,
    _state: PhantomData<State>,
}

struct OrderItem {
    product_id: ProductId,
    quantity: Quantity,
    price: Money,
}

// ===== State Transitions =====

impl Order<Draft> {
    fn new(user_id: UserId) -> Self {
        Order {
            id: OrderId(Uuid::new_v4()),
            user_id,
            items: Vec::new(),
            total: Money(Decimal::ZERO),
            _state: PhantomData,
        }
    }

    fn add_item(mut self, product_id: ProductId, quantity: Quantity, price: Money) -> Self {
        self.items.push(OrderItem {
            product_id,
            quantity,
            price,
        });
        self
    }

    fn validate(self) -> Result<Order<Validated>, ValidationError> {
        if self.items.is_empty() {
            return Err(ValidationError::EmptyOrder);
        }

        let total = self.items.iter()
            .map(|item| item.price)
            .fold(Money(Decimal::ZERO), |acc, price| acc.add(&price));

        Ok(Order {
            id: self.id,
            user_id: self.user_id,
            items: self.items,
            total,
            _state: PhantomData,
        })
    }
}

impl Order<Validated> {
    fn pay(self, payment: Payment) -> Result<Order<Paid>, PaymentError> {
        if payment.amount.0 != self.total.0 {
            return Err(PaymentError::AmountMismatch);
        }

        // Process payment...

        Ok(Order {
            id: self.id,
            user_id: self.user_id,
            items: self.items,
            total: self.total,
            _state: PhantomData,
        })
    }
}

impl Order<Paid> {
    fn ship(self, tracking: TrackingNumber) -> Result<Order<Shipped>, ShippingError> {
        // Create shipment...

        Ok(Order {
            id: self.id,
            user_id: self.user_id,
            items: self.items,
            total: self.total,
            _state: PhantomData,
        })
    }
}

impl Order<Shipped> {
    fn complete(self) -> Order<Completed> {
        Order {
            id: self.id,
            user_id: self.user_id,
            items: self.items,
            total: self.total,
            _state: PhantomData,
        }
    }
}

// ===== Repository Pattern (Dependency Inversion) =====

trait OrderRepository {
    fn save<S>(&self, order: &Order<S>) -> Result<(), RepositoryError>;
    fn find_by_id(&self, id: OrderId) -> Result<Option<Order<Draft>>, RepositoryError>;
}

struct PostgresOrderRepository {
    pool: PgPool,
}

impl OrderRepository for PostgresOrderRepository {
    fn save<S>(&self, order: &Order<S>) -> Result<(), RepositoryError> {
        // Postgres-specific implementation
        Ok(())
    }

    fn find_by_id(&self, id: OrderId) -> Result<Option<Order<Draft>>, RepositoryError> {
        // Postgres-specific implementation
        Ok(None)
    }
}

// ===== Service Layer (Single Responsibility) =====

struct OrderCreationService<R: OrderRepository> {
    repository: R,
}

impl<R: OrderRepository> OrderCreationService<R> {
    fn create_order(&self, user_id: UserId, items: Vec<(ProductId, Quantity, Money)>) -> Result<OrderId, OrderError> {
        let mut order = Order::<Draft>::new(user_id);

        for (product_id, quantity, price) in items {
            order = order.add_item(product_id, quantity, price);
        }

        let validated_order = order.validate()
            .map_err(|e| OrderError::Validation(e))?;

        self.repository.save(&validated_order)
            .map_err(|e| OrderError::Repository(e))?;

        Ok(validated_order.id)
    }
}

// ===== Usage Example =====

fn checkout_flow() -> Result<Order<Completed>, CheckoutError> {
    let order = Order::<Draft>::new(user_id)
        .add_item(product_id_1, Quantity(2), Money(Decimal::new(1999, 2)))
        .add_item(product_id_2, Quantity(1), Money(Decimal::new(4999, 2)))
        .validate()?       // Draft → Validated
        .pay(payment)?     // Validated → Paid
        .ship(tracking)?   // Paid → Shipped
        .complete();       // Shipped → Completed

    Ok(order)
}
```

### Example 2: Authentication System

```rust
// ===== Domain Types =====

struct Email(String);
struct Password(String);
struct HashedPassword(String);
struct SessionToken(String);
struct UserId(Uuid);

impl Email {
    fn new(s: String) -> Result<Self, ValidationError> {
        if !s.contains('@') || !s.contains('.') {
            return Err(ValidationError::InvalidEmail);
        }
        Ok(Email(s))
    }
}

impl Password {
    fn new(s: String) -> Result<Self, ValidationError> {
        if s.len() < 8 {
            return Err(ValidationError::PasswordTooShort);
        }
        Ok(Password(s))
    }

    fn hash(&self) -> HashedPassword {
        // Use bcrypt or argon2
        HashedPassword("hashed".to_string())
    }
}

// ===== User Aggregate =====

struct User {
    id: UserId,
    email: Email,
    password_hash: HashedPassword,
}

impl User {
    fn new(email: Email, password: Password) -> Self {
        User {
            id: UserId(Uuid::new_v4()),
            email,
            password_hash: password.hash(),
        }
    }

    fn verify_password(&self, password: &Password) -> bool {
        // Compare hashes
        true
    }
}

// ===== Repository Abstraction (DIP) =====

trait UserRepository {
    fn save(&self, user: User) -> Result<UserId, RepositoryError>;
    fn find_by_email(&self, email: &Email) -> Result<Option<User>, RepositoryError>;
    fn find_by_id(&self, id: UserId) -> Result<Option<User>, RepositoryError>;
}

trait SessionRepository {
    fn create_session(&self, user_id: UserId) -> Result<SessionToken, RepositoryError>;
    fn find_user_by_token(&self, token: &SessionToken) -> Result<Option<UserId>, RepositoryError>;
    fn invalidate_session(&self, token: &SessionToken) -> Result<(), RepositoryError>;
}

// ===== Authentication Service (SRP) =====

struct AuthenticationService<U: UserRepository, S: SessionRepository> {
    user_repo: U,
    session_repo: S,
}

impl<U: UserRepository, S: SessionRepository> AuthenticationService<U, S> {
    fn register(&self, email: Email, password: Password) -> Result<UserId, AuthError> {
        // Check if user exists
        if self.user_repo.find_by_email(&email)?.is_some() {
            return Err(AuthError::EmailAlreadyExists);
        }

        let user = User::new(email, password);
        let user_id = self.user_repo.save(user)
            .map_err(|e| AuthError::Repository(e))?;

        Ok(user_id)
    }

    fn login(&self, email: Email, password: Password) -> Result<SessionToken, AuthError> {
        let user = self.user_repo.find_by_email(&email)?
            .ok_or(AuthError::InvalidCredentials)?;

        if !user.verify_password(&password) {
            return Err(AuthError::InvalidCredentials);
        }

        let session_token = self.session_repo.create_session(user.id)
            .map_err(|e| AuthError::Repository(e))?;

        Ok(session_token)
    }

    fn verify_session(&self, token: &SessionToken) -> Result<UserId, AuthError> {
        self.session_repo.find_user_by_token(token)?
            .ok_or(AuthError::InvalidSession)
    }

    fn logout(&self, token: &SessionToken) -> Result<(), AuthError> {
        self.session_repo.invalidate_session(token)
            .map_err(|e| AuthError::Repository(e))
    }
}

// ===== Error Types =====

#[derive(Debug)]
enum AuthError {
    EmailAlreadyExists,
    InvalidCredentials,
    InvalidSession,
    Repository(RepositoryError),
    Validation(ValidationError),
}

#[derive(Debug)]
enum ValidationError {
    InvalidEmail,
    PasswordTooShort,
}

#[derive(Debug)]
enum RepositoryError {
    DatabaseError(String),
    NotFound,
}
```

---

## Principles Summary Card

**Copy this section for quick reference:**

### Type-Driven Design
- Make illegal states unrepresentable
- Use Newtype for ALL domain primitives
- Encode state machines in types (Typestate)
- Enums > Booleans for domain concepts

### SOLID
- **S**ingle Responsibility: One reason to change
- **O**pen/Closed: Extend via traits, not modification
- **L**iskov Substitution: Implementations honor contracts
- **I**nterface Segregation: Many specific traits > one fat trait
- **D**ependency Inversion: Depend on abstractions

### Simplicity
- **YAGNI**: Build what you need today
- **KISS**: Simple > Clever
- **Rule of Three**: Abstract on 3rd use, not before
- **DRY**: But not at cost of coupling

### Patterns
- **Newtype**: Domain primitives
- **Typestate**: Lifecycle states
- **RAII**: Resource management
- **Builder**: Complex construction
- **Factory**: Runtime-dependent creation
- **Iterator**: Lazy sequences

### Never Do
- ❌ String/i64/f64 for domain concepts
- ❌ Boolean parameters
- ❌ God objects
- ❌ .unwrap() in production code
- ❌ Silent error swallowing
- ❌ Premature abstraction

---

**Remember**: If it compiles and the types are right, it's probably correct. The type system is your best documentation and debugging tool.

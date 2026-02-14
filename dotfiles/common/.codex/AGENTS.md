# AGENTS.md - Rust Backend Development Standards

- **Audience**: All coding agents and language models (model-agnostic memory file).

- **Philosophy**: Make illegal states unrepresentable. Type safety > Runtime checks > Tests > Documentation
- **Last Updated**: 2026-02-12

______________________________________________________________________

## 1. Priority Hierarchy

**Tier 1 — Correctness**: Type-driven design, make illegal states unrepresentable, explicit over implicit
**Tier 2 — Simplicity**: YAGNI, KISS, Rule of Three (don't abstract before 3rd use)
**Tier 3 — Maintainability**: SOLID, DRY (not at cost of coupling), RAII

## 2. Golden Rules

**ALWAYS:**

- Newtype for domain primitives (IDs, emails, money, URLs, etc.)
- Enums over booleans for domain concepts
- Typed errors via `thiserror`, never `String` or generic errors
- RAII for resource management (implement `Drop`)
- Depend on traits, not concrete types (Dependency Inversion)
- Errors must say WHAT failed and WHERE

**NEVER:**

- Primitives for domain concepts (`String` for IDs, `f64` for money, `i64` timestamps)
- Boolean parameters — use enums: `Priority::Urgent` not `urgent: true`
- `.unwrap()` / `.expect()` in library/application code (tests/examples only)
- Silent error swallowing (`.ok()`, `.unwrap_or_default()` hiding failures)
- God objects or god functions
- Abstractions before 3rd use (Rule of Three)

**NUANCED:**

- `let-else` is the preferred alternative to `.unwrap()`: `let Some(x) = val else { return Err(...) };`
- `.expect("reason")` is acceptable ONLY at program init boundaries (before main logic)
- `unreachable!()` is acceptable when state is impossible by construction — add a comment explaining why

______________________________________________________________________

## 3. Type-Driven Design

> "If it compiles, it works" should be the goal.

**Step 1: Newtype for domain primitives** — zero-cost wrappers that prevent mixing incompatible values:

```rust
struct UserId(Uuid);
struct Money(Decimal); // NEVER f64 for money
fn transfer(from: UserId, to: UserId, amount: Money) -> Result<(), TransferError>
```

**Step 2: Enums over booleans** — self-documenting, exhaustive:

```rust
// ❌ process_payment(100.0, true, false, true) — what do these mean?
// ✅ process_payment(amount, PaymentType::Recurring{..}, PaymentStage::Final, Environment::Test)
```

**Step 3: Make illegal states unrepresentable** — encode invariants in types:

```rust
// ❌ struct Cart { items: Vec<Item>, checked_out: bool } — empty + checked_out?
// ✅ enum Cart { Empty, Active { items: NonEmptyVec<Item> }, CheckedOut { order_id: OrderId, items: NonEmptyVec<Item> } }
```

**Step 4: Flatten nested Option/Result** — custom enums over `Option<Result<Option<T>>>`:

```rust
enum UserEmailLookup { Found(Email), UserNotFound, EmailNotSet, DatabaseError(Error) }
```

______________________________________________________________________

## 4. Pattern Catalog

### Newtype — ALWAYS use for domain primitives

IDs, emails, money, coordinates, passwords, connection strings, bucket names.
Validate in constructor, return `Result`. Type exists = value is valid.

### Typestate — Compile-time state machine enforcement

```rust
struct Connection<State> { socket: TcpStream, _state: PhantomData<State> }
// Disconnected → Connected → Authenticated — each state has distinct methods
```

**When to use**: States have truly disjoint operations, you need compile-time guarantees.
**When NOT to use** (use enum instead):

- States share >80% of methods
- State determined at runtime from external input (deserialized data, config)
- Need to store objects of different states in the same collection
- Serialization required (Typestate + serde is fragile)
- Only 2 simple states (use `Option` or `Result`)

**Default**: Start with enum. Upgrade to Typestate only when needed.

### RAII — Lifetime = Scope

Implement `Drop` for resource needing cleanup (connections, files, locks, temp dirs).
Cleanup happens even on panic or early return. No manual cleanup code needed.

**Async caveat**: `Drop` cannot be async. Use sync cleanup in `Drop`, or provide an explicit async `close()` method alongside `Drop` as fallback.

### Builder — Complex construction with validation

Use when 4+ parameters or cross-field validation needed. Validate in `build()`, return `Result`:

```rust
let user = UserBuilder::new()
    .email(email).username(name).age(age)
    .build()?; // Validates all fields, returns Result<User, ValidationError>
```

### Factory — Runtime-dependent creation

Use when creation depends on config/runtime input and multiple implementations exist behind one trait.
Prefer enum dispatch over `Box<dyn Trait>` when all types are known at compile time.

### Decision Flowchart

```
Domain concept (ID, email, money)?     → Newtype
Multiple states, disjoint operations?  → Typestate (or enum, see rules above)
Complex construction (4+ params)?      → Builder
Runtime-dependent creation?            → Factory
Need polymorphism, known types?        → Enum
Need polymorphism, unknown types?      → Trait + trait objects
Managing resources?                    → RAII (implement Drop)
Custom collection?                     → Implement Iterator
```

______________________________________________________________________

## 5. SOLID (Compact)

- **S** — Single Responsibility: One struct/module = one reason to change. Split god objects into Repository + Service + Orchestrator.
- **O** — Open/Closed: Extend via traits, don't modify existing code. `trait PaymentProcessor` + `StripeProcessor`, `PayPalProcessor`.
- **L** — Liskov Substitution: All trait impls must honor the contract. Document invariants in trait docs.
- **I** — Interface Segregation: `trait Readable` + `trait Writable` > `trait DataStore` with 6 methods. Consumers specify exactly what they need: `fn sync<R: Readable + Writable>`.
- **D** — Dependency Inversion: `struct Service<R: Repository>` not `struct Service { db: PostgresDb }`. Enables testing with mocks.

______________________________________________________________________

## 6. Error Handling Strategy

### Hierarchy Design

- One error enum per module/crate boundary (not per function)
- `thiserror` for typed errors in libraries and modules
- `anyhow` only in binary `main()` and top-level orchestration
- `#[from]` for automatic conversion, manual `From` when sanitization needed

### Async Error Propagation

- `tokio::spawn` returns `Result<T, JoinError>` — always handle both layers
- Flatten: `handle.await.context("task panicked")?.context("task failed")?`
- Wrap timeouts: `tokio::time::timeout(dur, fut).await.map_err(|_| MyError::Timeout)?`

### Sensitive Data

- NEVER include passwords, tokens, or connection strings in error messages
- Use redacting wrapper types (SecretString pattern): `Debug` shows `***REDACTED***`, explicit `.reveal()` for access
- Sanitize SDK errors before logging (strip raw response bodies)

______________________________________________________________________

## 7. Async & Concurrency Patterns

### Send/Sync

- `tokio::spawn` requires `Send + 'static` — no `Rc`, no `MutexGuard` held across `.await`
- If `!Send` is acceptable (single-threaded runtime), document it explicitly

### Shared State

- `std::sync::Mutex` — for short critical sections NOT held across `.await`
- `tokio::sync::Mutex` — when lock must be held across `.await` points
- Prefer channels (`mpsc`, `oneshot`, `broadcast`) over shared mutable state when possible

### Cancel Safety

- `tokio::select!` cancels the losing branch — ensure operations are cancel-safe
- Reads from channels are cancel-safe; partial writes are NOT
- If an operation is not cancel-safe, run it in a separate task and await the `JoinHandle`

### RAII in Async

- `Drop` cannot run async code — use sync cleanup (e.g., `std::fs::remove_dir_all` in Drop)
- For async cleanup, provide `async fn close(self) -> Result<()>` and call `Drop` as fallback
- Use `Arc<Mutex<Inner>>` pattern when multiple tasks share a resource with cleanup

______________________________________________________________________

## 8. Testing Patterns

### Organization

- Unit tests co-located in source files: `#[cfg(test)] mod tests { use super::*; ... }`
- Integration tests in `tests/` directory
- Use `#[tokio::test]` for async tests, `#[tokio::test(flavor = "multi_thread")]` when needed

### Trait-Based Mocking (via DI)

```rust
struct MockRepo { users: Vec<User> }
impl UserRepository for MockRepo {
    fn find_by_id(&self, id: UserId) -> Result<Option<User>> { /* return from vec */ }
}
// Test: let service = UserService { repo: MockRepo { users: vec![test_user] } };
```

### Error Path Testing

```rust
// ❌ assert!(result.is_err());
// ✅ Assert specific variant:
let err = result.unwrap_err(); // .unwrap() is fine in tests
assert!(matches!(err, AuthError::InvalidCredentials));
```

### What NOT to Test

- Type mechanics the compiler already verifies (Newtype wrapping, enum exhaustiveness)
- Trivial getters/setters
- Third-party library behavior

______________________________________________________________________

## 9. Configuration & Secrets

### Layered Config

File defaults → environment overrides → CLI args. Validate ALL config at startup, fail fast.

### Secret Types

```rust
struct SecretString(String);
impl fmt::Debug for SecretString { fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result { write!(f, "***") } }
impl fmt::Display for SecretString { fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result { write!(f, "***") } }
impl SecretString { fn reveal(&self) -> &str { &self.0 } }
```

- Wrap passwords, tokens, API keys, connection strings
- `Debug`/`Display` always redact — explicit `.reveal()` for actual value
- Serde `Serialize` can preserve actual value (for config serialization), but `Debug` must redact

______________________________________________________________________

## 10. Anti-Patterns (Quick Reference)

| Anti-Pattern | Fix |
|---|---|
| Stringly-typed (`fn get(id: String)`) | Newtype (`fn get(id: UserId)`) |
| Boolean blindness (`urgent: bool`) | Enum (`Priority::Urgent`) |
| Primitive obsession (`price: f64`) | Domain type (`price: Money`) |
| Error swallowing (`.unwrap_or_default()`) | Typed Result + `.context()` |
| God object (20 fields, 500-line method) | Split into focused services |
| Premature abstraction (trait on 1st use) | Rule of Three — wait |
| Option/Result hell (`Option<Result<Option<T>>>`) | Custom enum |
| Clone to satisfy borrow checker | Restructure ownership, use references or `Arc` |

______________________________________________________________________

## 11. Code Review Checklist

**Type Safety**: Newtype for domain primitives, enums over booleans, invalid states unrepresentable
**SOLID**: Single responsibility, traits not concrete types, specific interfaces, no god objects
**Errors**: Typed enums, context on every `?`, no `.unwrap()` in prod, secrets redacted
**Async**: `JoinError` handled, cancel safety considered, correct Mutex type, semaphore for backpressure
**Resources**: RAII for all resources, no manual cleanup, no leaks on panic
**Tests**: Error paths tested with specific variants, mocks via trait DI, `#[tokio::test]`
**Simplicity**: No speculative features, no premature abstraction, straightforward solutions

______________________________________________________________________

## 12. Principles Summary Card

**Types**: Newtype for primitives, enums over booleans, illegal states unrepresentable
**SOLID**: S=one responsibility, O=extend via traits, L=honor contracts, I=specific traits, D=depend on abstractions
**Simplicity**: YAGNI, KISS, Rule of Three, DRY (not at cost of coupling)
**Errors**: One enum per boundary, context on every `?`, `thiserror` in libs, `anyhow` in binaries, sanitize secrets
**Async**: Channels > shared state, cancel-safe by default, handle JoinError, Drop can't be async
**Testing**: Test error paths with specific variants, mock via traits, don't test compiler guarantees
**Patterns**: Newtype, Typestate (only when disjoint ops), RAII, Builder, Factory, Iterator

**Remember**: If it compiles and the types are right, it's probably correct.

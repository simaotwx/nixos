# NixOS Configuration Architecture

## Design Principles

### Import-Based Composition
- **Prefer explicit imports over configuration flags** - modules are imported when needed, not enabled via options
- **Single-purpose modules** - each module has one clear responsibility
- **No hidden dependencies** - all module dependencies are explicit through imports

### Option Namespace Design

#### Target Namespace (`target.*`)
Used for deployment-specific configuration decisions that affect how the system is built and deployed:

- **`target.storage.*`** - storage and filesystem architecture decisions
- **`target.images.*`** - image generation configuration  
- **`target.sysupdate.*`** - system update mechanisms
- **`target.boot.*`** - boot-time deployment behavior

#### Integration with Existing NixOS Namespaces
- **`system.image.*`** - extend existing image namespace for NixOS compatibility
- **`boot.*`** - extend for purely boot-related configurations
- **Avoid `fileSystems.*`** - this is managed by upstream NixOS modules

### Storage Architecture

#### System vs Persistent Storage Separation
- **`target.storage.system.readOnly`** - whether OS/system storage is immutable
- **`target.storage.persistent.*`** - for user data, logs, and mutable state
- **Clear separation** - system immutability doesn't prevent persistent data storage

#### Read-Only vs Read-Write Systems
- **Read-only systems**: Separate EROFS `/nix/store` partition, tmpfs root, optional persistent `/var`
- **Read-write systems**: Traditional BTRFS with subvolumes, mutable filesystem
- **Composable modules** - import appropriate modules for system type

### Module Organization

#### Orthogonal Concerns
Instead of monolithic profiles, break functionality into orthogonal modules:
- **`modules/filesystem/`** - filesystem mount configurations
- **`modules/images/`** - image generation (read-only, A/B, etc.)
- **`modules/boot/`** - boot-time behavior (systemd-repart, etc.)
- **`modules/updates/`** - update mechanisms (systemd-sysupdate, A/B partitions)

#### Compatibility Constraints
- **Assertions over enable flags** - modules assert compatibility rather than having enable options
- **Automatic behavior** - modules automatically configure themselves based on `target.*` settings
- **Prevent illogical combinations** - e.g., read-only image generation with writable filesystem modules

### Option Design Patterns

#### Prefer `lib.mkEnableOption`
```nix
# Good - concise, standard pattern
target.storage.system.readOnly = lib.mkEnableOption "read-only system storage (immutable OS)";

# Avoid - verbose, non-standard
target.storage.system.readOnly = lib.mkOption {
  type = lib.types.bool;
  default = false;
  description = "Whether the system storage should be read-only (immutable OS)";
};
```

#### Ask Fundamental Questions
Design options around the core decisions rather than implementation details:
- **Ask**: "Should the system be read-only?" 
- **Don't ask**: "Should we enable the nix-store module?"

## Multi-Architecture Support

### Architecture Awareness
- **`config.nixpkgs.hostPlatform.efiArch`** - automatic EFI architecture detection
- **Conditional imports** - modules adapt to x86_64, arm64, etc.
- **Future-proofing** - design for additional architectures (RISC-V, etc.)

## Future Extensions

### Security and Verification
- **`modules/security/dm-verity.nix`** - filesystem integrity verification
- **`modules/security/secure-boot.nix`** - UEFI secure boot chain
- **`modules/security/tpm.nix`** - TPM-based attestation

### Update Mechanisms
- **A/B partitions** - dual boot partitions for atomic updates
- **systemd-sysupdate** - modern update mechanism
- **Custom update channels** - organization-specific update sources

## Partition Numbering Scheme

### systemd-repart Partition Order
Partitions are numbered to ensure consistent ordering across different layouts:

- **00-09**: Reserved/Special partitions
- **10-19**: Boot partitions (ESP, boot, etc.)
- **20-49**: System partitions (store, store-empty, system root, etc.)
- **50-59**: User data partitions
- **60-99**: Variable/runtime partitions (var, tmp, logs, etc.)

### Standard Partition Assignments
- **10-esp**: EFI System Partition
- **20-store**: Read-only Nix store (active)
- **25-store-empty**: Read-only Nix store (A/B inactive)
- **30-root**: Read-write system root (for non-read-only systems)
- **70-var**: Variable data partition
- **80-tmp**: Temporary storage (if separate)

### Layout-Specific Allocations
Different partition layouts use different subsets:

**A-only layout**:
- 10-esp, 20-store, 70-var (optional)

**A/B layout**: 
- 10-esp, 20-store, 25-store-empty, 70-var (optional)

**Read-write layout**:
- 10-esp, 30-root, 50-home (optional)

This architecture enables scalable, maintainable NixOS deployments while maintaining clear separation of concerns and preventing configuration conflicts.
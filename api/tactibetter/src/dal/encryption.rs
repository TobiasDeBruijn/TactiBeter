use chacha20poly1305::aead::{Aead, NewAead};
use chacha20poly1305::{Key, XChaCha20Poly1305, XNonce};
use rand::RngCore;
use crate::dal::{DalError, DalResult};

/// Represents encrypted data
pub struct Encrypted {
    /// The encrypted data
    pub ciphertext: Vec<u8>,
    /// The nonce used during encryption
    pub nonce: Vec<u8>,
}

/// Decrypt data
///
/// # Errors
///
/// If decryption failed
///
/// # Panics
///
/// If the key is not 32 bytes long
pub fn decrypt(key: &[u8], nonce: &[u8], encrypted: &[u8]) -> DalResult<Vec<u8>> {
    let key = Key::from_slice(key);

    let cipher = XChaCha20Poly1305::new(key);

    let nonce = XNonce::from_slice(nonce);

    let decrypted = cipher.decrypt(nonce, encrypted).map_err(|_| DalError::ChaCha20Poly1305)?;

    Ok(decrypted)
}

/// Encrypt data
///
/// # Errors
///
/// If the encryption fails
///
/// # Panics
///
/// If the key is not exactly 32 bytes
pub fn encrypt(key: &[u8], decrypted: &[u8]) -> DalResult<Encrypted> {
    let key = Key::from_slice(key);

    let cipher = XChaCha20Poly1305::new(key);

    let mut nonce_bytes = [0u8; 24];

    rand::thread_rng().fill_bytes(&mut nonce_bytes);

    let nonce = XNonce::from(nonce_bytes);

    let encrypted = cipher.encrypt(&nonce, decrypted).map_err(|_| DalError::ChaCha20Poly1305)?;

    Ok(Encrypted {
        ciphertext: encrypted,
        nonce: nonce_bytes.to_vec(),
    })
}

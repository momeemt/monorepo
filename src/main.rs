use std::{env, fs::File, io::Read};

use anyhow::Result;
use runw::execution::{runtime::Runtime, wasi::WasiSnapshotPreview1};

fn main() -> Result<()> {
    let wasi = WasiSnapshotPreview1::new();
    let args: Vec<String> = env::args().collect();
    let mut wasm_file = File::open(&args[1])?;
    let mut wasm = Vec::new();
    let _ = wasm_file.read_to_end(&mut wasm)?;
    let mut runtime = Runtime::instantiate_with_wasi(wasm, wasi)?;
    runtime.call("_start", vec![]).unwrap();
    Ok(())
}

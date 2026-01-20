use std::collections::HashMap;

use anyhow::Result;

use super::{store::Store, value::Value};

pub type ImportFunc = Box<dyn FnMut(&mut Store, Vec<Value>) -> Result<Option<Value>>>;
pub type Import = HashMap<String, HashMap<String, ImportFunc>>;

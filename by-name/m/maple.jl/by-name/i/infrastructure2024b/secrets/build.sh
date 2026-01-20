ENVRC_PATH=".envrc"
BACKEND_HCL="terraform/backend.hcl"
SECRETS_YML_PATH="secrets/secrets.yml"

function get_secret() {
  key=$1
  echo $(sops -d $SECRETS_YML_PATH | yq eval $key -)
}

MINIO_ROOT_USER="$(get_secret '.minio-root-user')"
MINIO_ROOT_PASSWORD="$(get_secret '.minio-root-password')"
MINIO_ACCESS_KEY="$(get_secret '.minio-access-key')"
MINIO_SECRET_KEY="$(get_secret '.minio-secret-key')"
MINIO_PORT="$(get_secret '.minio-port')"
MINIO_CONSOLE_PORT="$(get_secret '.minio-console-port')"
TERRAFORM_ENDPOINT="$(get_secret '.terraform-endpoint')"
TERRAFORM_REGION="$(get_secret '.terraform-region')"

echo "use flake" > $ENVRC_PATH
echo "export MINIO_ROOT_USER='$MINIO_ROOT_USER'" >> $ENVRC_PATH
echo "export MINIO_ROOT_PASSWORD='$MINIO_ROOT_PASSWORD'" >> $ENVRC_PATH
echo "export MINIO_ACCESS_KEY='$MINIO_ACCESS_KEY'" >> $ENVRC_PATH
echo "export MINIO_SECRET_KEY='$MINIO_SECRET_KEY'" >> $ENVRC_PATH
echo "export MINIO_PORT='$MINIO_PORT'" >> $ENVRC_PATH
echo "export MINIO_CONSOLE_PORT='$MINIO_CONSOLE_PORT'" >> $ENVRC_PATH

echo "region = \"$TERRAFORM_REGION\"" >> $BACKEND_HCL
echo "access_key = \"$MINIO_ACCESS_KEY\"" >> $BACKEND_HCL
echo "secret_key = \"$MINIO_SECRET_KEY\"" >> $BACKEND_HCL


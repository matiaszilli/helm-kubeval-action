#!/bin/sh

# Exit on error.
set -e;

CURRENT_DIR=$(pwd);

run_kubeval() {
    # Validate all generated manifest against Kubernetes json schema
    cd "$1"
    VALUES_FILE="$2"
    mkdir helm-output;
    helm template --values "$VALUES_FILE" --output-dir helm-output .;
    find helm-output -type f -exec \
        /kubeval/kubeval \
            "-o=$OUTPUT" \
            "--strict=$STRICT" \
            "--kubernetes-version=$KUBERNETES_VERSION" \
            "--openshift=$OPENSHIFT" \
            "--ignore-missing-schemas=$IGNORE_MISSING_SCHEMAS" \
        {} +;
    rm -rf helm-output;
}

printenv

helm repo add stable https://kubernetes-charts.storage.googleapis.com/;

# For all charts (i.e for every directory) in the directory
for CHART in "$CHARTS_PATH"; do
    echo "Validating $CHART Helm Chart...";
    cd "$CURRENT_DIR/$CHART";
    helm dependency build;

    echo "Validating $CHART Helm Chart using values.yaml values file...";
    run_kubeval "$(pwd)" "values.yaml"

    for VALUES_FILE in values-*.yaml; do
        echo "Validating $CHART Helm Chart using $VALUES_FILE values file...";
        run_kubeval "$(pwd)" "$VALUES_FILE"
    done
done

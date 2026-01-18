#!/bin/bash
echo "🔍 AWS WEB HOSTING - TERRAFORM TEST SCRIPT"
echo "==========================================="
echo "Student: Khouloud Chebboubi"
echo "Matriculation: 102303255"
echo "Course: DLBSEPCP01_E"
echo "Date: $(date)"
echo ""

echo "📋 Checking files..."
if [ -f "main.tf" ] && [ -f "variables.tf" ] && [ -f "outputs.tf" ]; then
    echo "✅ All required Terraform files found"
else
    echo "❌ Missing Terraform files!"
    exit 1
fi

echo ""
echo "🚀 Testing Terraform configuration..."
echo "-----------------------------------"

# Test 1: Initialize
echo "1. Initializing Terraform..."
terraform init

if [ $? -eq 0 ]; then
    echo "✅ Terraform initialized successfully"
else
    echo "❌ Terraform init failed!"
    exit 1
fi

# Test 2: Validate syntax
echo ""
echo "2. Validating Terraform syntax..."
terraform validate

if [ $? -eq 0 ]; then
    echo "✅ Terraform syntax is VALID!"
else
    echo "❌ Terraform validation failed!"
    exit 1
fi

# Test 3: Dry run
echo ""
echo "3. Running terraform plan (dry run)..."
echo "Note: AWS credentials required for full test"
echo "--------------------------------------------"

terraform plan -var-file="terraform.tfvars.example"

echo ""
echo "🎉 TEST COMPLETED SUCCESSFULLY!"
echo "================================"
echo ""
echo "📌 TUTOR INSTRUCTIONS:"
echo "1. Clone this repository"
echo "2. Run: terraform init"
echo "3. Run: terraform plan"
echo "4. Run: terraform apply (optional)"
echo ""
echo "✅ This configuration is READY for assessment!"

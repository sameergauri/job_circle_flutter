{
    "display": "form",
    "settings": {
        "pdf": {
            "id": "1ec0f8ee-6685-5d98-a847-26f67b67d6f0",
            "src": "https://files.form.io/pdf/5692b91fd1028f01000407e3/file/1ec0f8ee-6685-5d98-a847-26f67b67d6f0"
        }
    },
    "components": [{
            "label": "Columns",
            "columns": [{
                    "components": [{
                        "label": "Pan No.",
                        "tableView": true,
                        "unique": true,
                        "key": "panNo",
                        "type": "textfield",
                        "input": true
                    }],
                    "width": 6,
                    "offset": 0,
                    "push": 0,
                    "pull": 0,
                    "size": "md",
                    "currentWidth": 6
                },
                {
                    "components": [],
                    "width": 6,
                    "offset": 0,
                    "push": 0,
                    "pull": 0,
                    "size": "md",
                    "currentWidth": 6
                }
            ],
            "key": "columns",
            "type": "columns",
            "input": false,
            "tableView": false
        },
        {
            "label": "Aadhar Card No",
            "mask": false,
            "tableView": false,
            "delimiter": false,
            "requireDecimal": false,
            "inputFormat": "plain",
            "truncateMultipleSpaces": false,
            "key": "aadharNo",
            "type": "number",
            "input": true
        },
        {
            "legend": "Bank Account Details",
            "key": "fieldSet",
            "type": "fieldset",
            "label": "Field Set",
            "input": false,
            "tableView": false,
            "components": [{
                    "label": "Account Holder Name",
                    "tableView": true,
                    "validate": {
                        "required": true
                    },
                    "key": "accountHolderName",
                    "type": "textfield",
                    "input": true
                },
                {
                    "label": "Bank Name",
                    "tableView": true,
                    "validate": {
                        "required": true
                    },
                    "key": "bankName",
                    "type": "textfield",
                    "input": true
                },
                {
                    "label": "IFSC Code",
                    "tableView": true,
                    "key": "ifscCode",
                    "type": "textfield",
                    "input": true
                },
                {
                    "label": "Account No.",
                    "tableView": true,
                    "validate": {
                        "required": true
                    },
                    "key": "accountNo",
                    "type": "textfield",
                    "input": true
                },
                {
                    "label": "Retype Account No",
                    "tableView": true,
                    "validate": {
                        "required": true
                    },
                    "key": "retypeAccountNo",
                    "type": "textfield",
                    "input": true
                },
                {
                    "label": "Select",
                    "widget": "choicesjs",
                    "tableView": true,
                    "data": {
                        "values": [{
                                "label": "Saving",
                                "value": "saving"
                            },
                            {
                                "label": "Current",
                                "value": "current"
                            }
                        ]
                    },
                    "key": "select",
                    "type": "select",
                    "input": true
                }
            ]
        },
        {
            "legend": "CONTACT / ADDRESS DETAILS",
            "key": "fieldSet1",
            "type": "fieldset",
            "label": "Field Set",
            "input": false,
            "tableView": false,
            "components": [{
                    "label": "Email",
                    "tableView": true,
                    "key": "email",
                    "type": "email",
                    "input": true
                },
                {
                    "label": "Mobile Number",
                    "tableView": true,
                    "key": "mobileNumber",
                    "type": "phoneNumber",
                    "input": true
                },
                {
                    "input": true,
                    "key": "address",
                    "tableView": false,
                    "label": "Address",
                    "type": "address",
                    "components": [{
                            "label": "Address 1",
                            "tableView": false,
                            "key": "address1",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "Address 2",
                            "tableView": false,
                            "key": "address2",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "City",
                            "tableView": false,
                            "key": "city",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "State",
                            "tableView": false,
                            "key": "state",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "Country",
                            "tableView": false,
                            "key": "country",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "Zip Code",
                            "tableView": false,
                            "key": "zip",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        }
                    ]
                },
                {
                    "input": true,
                    "key": "address1",
                    "tableView": false,
                    "label": "Address",
                    "type": "address",
                    "components": [{
                            "label": "Address 1",
                            "tableView": false,
                            "key": "address1",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "Address 2",
                            "tableView": false,
                            "key": "address2",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "City",
                            "tableView": false,
                            "key": "city",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "State",
                            "tableView": false,
                            "key": "state",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "Country",
                            "tableView": false,
                            "key": "country",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        },
                        {
                            "label": "Zip Code",
                            "tableView": false,
                            "key": "zip",
                            "type": "textfield",
                            "input": true,
                            "customConditional": "show = _.get(instance, 'parent.manualMode', false);"
                        }
                    ]
                },
                {
                    "label": "Landmark",
                    "tableView": true,
                    "key": "landmark",
                    "type": "textfield",
                    "input": true
                },
                {
                    "label": "Pincode",
                    "mask": false,
                    "tableView": false,
                    "delimiter": false,
                    "requireDecimal": false,
                    "inputFormat": "plain",
                    "truncateMultipleSpaces": false,
                    "key": "pincode",
                    "type": "number",
                    "input": true
                },
                {
                    "label": "Country",
                    "widget": "choicesjs",
                    "tableView": true,
                    "key": "country",
                    "type": "select",
                    "input": true
                },
                {
                    "label": "City",
                    "widget": "choicesjs",
                    "tableView": true,
                    "key": "city",
                    "type": "select",
                    "input": true
                },
                {
                    "label": "State",
                    "widget": "choicesjs",
                    "tableView": true,
                    "key": "state",
                    "type": "select",
                    "input": true
                }
            ]
        },
        {
            "legend": "ESCALATION DESK",
            "key": "fieldSet2",
            "type": "fieldset",
            "label": "Field Set",
            "input": false,
            "tableView": false,
            "components": [{
                    "legend": "Level 1",
                    "key": "fieldSet3",
                    "type": "fieldset",
                    "label": "Field Set",
                    "input": false,
                    "tableView": false,
                    "components": [{
                            "label": "Phone Number",
                            "tableView": true,
                            "key": "phoneNumber",
                            "type": "phoneNumber",
                            "input": true
                        },
                        {
                            "label": "Email",
                            "tableView": true,
                            "key": "email2",
                            "type": "email",
                            "input": true
                        }
                    ]
                },
                {
                    "legend": "Level2",
                    "key": "fieldSet4",
                    "type": "fieldset",
                    "label": "Field Set",
                    "input": false,
                    "tableView": false,
                    "components": []
                },
                {
                    "label": "Phone Number",
                    "tableView": true,
                    "key": "phoneNumber1",
                    "type": "phoneNumber",
                    "input": true
                },
                {
                    "label": "Email",
                    "tableView": true,
                    "key": "email1",
                    "type": "email",
                    "input": true
                }
            ]
        },
        {
            "label": "SUBMIT",
            "showValidations": false,
            "tableView": false,
            "key": "submit1",
            "type": "button",
            "input": true,
            "saveOnEnter": false
        }
    ]
}
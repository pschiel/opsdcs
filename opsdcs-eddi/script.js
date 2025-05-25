document.addEventListener('DOMContentLoaded', () => {
    const widgetToolbar = document.getElementById('widget-toolbar');
    const dialogCanvas = document.getElementById('dialog-canvas');
    const propertiesSidebarContent = document.getElementById('widget-properties-content');
    const skinDetailsContent = document.getElementById('skin-details-content');
    const saveDialogButton = document.getElementById('save-dialog-button');

    let selectedItem = null; 
    let widgetCounter = 0;

    if (!dialogCanvas.dataset.properties) {
        dialogCanvas.dataset.properties = JSON.stringify({
            id: 'dialog-canvas',
            text: 'MyDialog',
            width: 600,
            height: 400,
            skinName: 'windowSkin',
            skinData: {
                params: { name: 'windowSkin' },
                states: {}
            }
        });
    }
    const initialDialogProps = JSON.parse(dialogCanvas.dataset.properties);
    dialogCanvas.style.width = `${initialDialogProps.width}px`;
    dialogCanvas.style.height = `${initialDialogProps.height}px`;

    const removeCanvasPlaceholder = () => {
        const placeholder = dialogCanvas.querySelector('.canvas-placeholder');
        const hasWidgets = dialogCanvas.querySelectorAll('.widget-on-canvas').length > 0;
        if (placeholder) {
            placeholder.style.display = hasWidgets ? 'none' : 'flex';
        }
    };

    const addWidgetToCanvas = (widgetType, parentElement = dialogCanvas) => {
        const widgetId = `widget-${widgetType}-${widgetCounter++}`;
        const widgetElement = document.createElement('div');
        widgetElement.id = widgetId;
        widgetElement.classList.add('widget-on-canvas');
        widgetElement.dataset.widgetType = widgetType;
        
        let defaultTextContent = `${widgetType.charAt(0).toUpperCase() + widgetType.slice(1)} #${widgetCounter}`; // Used for initial display if text prop not set
        let initialWidth = 100;
        let initialHeight = 30;
        const additionalProps = {}; // For props not in commonProps initially

        // First switch: setup initial dimensions, default text for some, and widget-specific additionalProps
        switch (widgetType) {
            case 'panel':
            case 'scrollpane':
            case 'treeview':
                initialWidth = 200;
                initialHeight = 150;
                defaultTextContent = ''; 
                widgetElement.classList.add('container-widget'); 
                break;
            case 'combobox':
                initialWidth = 120;
                defaultTextContent = 'ComboBox'; // This is more of a placeholder, actual text prop might be different
                additionalProps.items = ['Item 1', 'Item 2', 'Item 3'];
                additionalProps.selectedIndex = 0;
                break;
            case 'combolist': 
                initialWidth = 120;
                initialHeight = 80;
                defaultTextContent = ''; 
                additionalProps.items = ['Option A', 'Option B', 'Option C'];
                break;
            case 'togglebutton':
                additionalProps.checked = false;
                defaultTextContent = 'ToggleButton';
                break;
            case 'editbox':
                initialWidth = 150;
                defaultTextContent = ''; // EditBox usually starts empty
                break;
            case 'grid': 
                initialWidth = 300;
                initialHeight = 200;
                defaultTextContent = ''; 
                widgetElement.classList.add('container-widget');
                break;
            case 'gridheadercell': 
                initialWidth = 100;
                initialHeight = 20;
                defaultTextContent = 'Header'; 
                break;
        }
        // widgetElement.textContent = defaultTextContent; // Set text content later based on finalProps.text

        const parentChildrenCount = parentElement.querySelectorAll(':scope > .widget-on-canvas').length;
        const initialX = 10 + (parentChildrenCount % 10) * 15; // Adjusted staggering
        const initialY = 10 + Math.floor(parentChildrenCount / 10) * 15; // Adjusted staggering
        
        const commonProps = {
            id: widgetId, // Use the generated widgetId
            parentId: parentElement.id, 
            type: widgetType,
            x: initialX,
            y: initialY,
            width: initialWidth,
            height: initialHeight,
            text: defaultTextContent, // Default text, might be overridden by widget-specific
            visible: true,
            enabled: true,
            tooltip: '',
            zindex: 0,
            skinName: 'defaultSkin', 
            skinData: { 
                params: { name: 'defaultSkin' }, 
                states: {} 
            },
            tabOrder: 0,
            children: [] 
        };

        let finalProps; // This will hold the complete properties object

        // Second switch: define the final set of properties for the widget type
        switch (widgetType) {
            case 'label':
                finalProps = { ...commonProps, skinName: 'StaticSkin', skinData: { params: { name: 'StaticSkin' }}, height: 20, text: 'NewLabel', ...additionalProps };
                break;
            case 'button':
                finalProps = { ...commonProps, skinName: 'ButtonSkin', skinData: { params: { name: 'ButtonSkin' }}, ...additionalProps };
                break;
            case 'panel':
            case 'treeview':
                finalProps = { ...commonProps, skinName: 'PanelSkin', skinData: { params: { name: 'PanelSkin' }}, text: '', ...additionalProps }; // text: '' for panels
                break;
            case 'scrollpane':
                finalProps = {
                    ...commonProps, skinName: 'ScrollPaneSkin', skinData: { params: { name: 'ScrollPaneSkin' }},
                    text: '', // text: '' for scrollpanes
                    vertScrollBarStep: 16,
                    horzScrollBarStep: 0,
                    vertMouseWheel: true,
                    horzMouseWheel: false,
                    ...additionalProps
                };
                break;
            case 'editbox':
                finalProps = { ...commonProps, skinName: 'EditBoxSkin', skinData: { params: { name: 'EditBoxSkin' }}, text: '', ...additionalProps }; // text: '' for editbox
                break;
            case 'checkbox':
                finalProps = { ...commonProps, skinName: 'CheckBoxSkin', skinData: { params: { name: 'CheckBoxSkin' }}, width: 120, text: 'Checkbox', checked: false, ...additionalProps };
                break;
            case 'togglebutton':
                finalProps = { ...commonProps, skinName: 'ToggleButtonSkin', skinData: { params: { name: 'ToggleButtonSkin' }}, width: 120, text: 'ToggleButton', checked: false, ...additionalProps };
                break;
            case 'combobox':
                finalProps = { ...commonProps, skinName: 'ComboBoxSkin', skinData: { params: { name: 'ComboBoxSkin' }}, width: 150, ...additionalProps }; // items and selectedIndex from additionalProps
                break;
            case 'combolist':
                 finalProps = { ...commonProps, skinName: 'ListBoxSkin', skinData: { params: { name: 'ListBoxSkin' }}, width: 150, text: '', ...additionalProps }; // items from additionalProps, text is usually empty
                 break;
            case 'grid':
                finalProps = {
                    ...commonProps, skinName: 'gridSkin', skinData: { params: { name: 'gridSkin' }},
                    text: '', // text: '' for grid
                    columns: JSON.stringify([
                        { attribute: 'col1', width: 100, align: 'left', title: 'Column 1' }, 
                        { attribute: 'col2', width: 100, align: 'left', title: 'Column 2' },
                        { attribute: 'col3', width: 98, align: 'left', title: 'Column 3' }
                    ], null, 2),
                    dataSource: 'your_lua_data_function_name',
                    rowHeight: 20,
                    vertScrollBar: true, horzScrollBar: false,
                    selectedAttributeColor: '0x00000000',
                    selectedRowColor: '0x87CEEB80',
                    useAlternatingRowColor: false, altRowColor: '0xF0F0F0FF',
                    ...additionalProps
                };
                break;
            case 'gridheadercell':
                finalProps = { ...commonProps, skinName: 'gridHeaderCellSkin', skinData: { params: { name: 'gridHeaderCellSkin' }}, ...additionalProps };
                break;
            default:
                finalProps = { ...commonProps, ...additionalProps };
                break;
        }

        widgetElement.dataset.properties = JSON.stringify(finalProps);

        // Apply initial styles for position and size
        widgetElement.style.position = 'absolute'; // Crucial for x, y to work
        widgetElement.style.left = `${finalProps.x}px`;
        widgetElement.style.top = `${finalProps.y}px`;
        widgetElement.style.width = `${finalProps.width}px`;
        widgetElement.style.height = `${finalProps.height}px`;
        widgetElement.style.zIndex = finalProps.zindex || 0;
        widgetElement.style.visibility = finalProps.visible ? 'visible' : 'hidden';

        // Set text content, considering container types
        if (widgetType !== 'panel' && widgetType !== 'scrollpane' && widgetType !== 'treeview' && widgetType !== 'grid' && widgetType !== 'combolist') {
            widgetElement.textContent = finalProps.text || '';
        } else {
            widgetElement.textContent = ''; // Clear text for pure containers or list-based
        }

        parentElement.appendChild(widgetElement);
        makeDraggable(widgetElement);
        selectItem(widgetElement); // Re-enabled for auto-selection
        removeCanvasPlaceholder();
        return widgetElement; // Return the actual DOM element
    };

    const selectItem = (element) => {
        if (selectedItem) {
            selectedItem.classList.remove('selected');
        }
        selectedItem = element;
        if (selectedItem){
            selectedItem.classList.add('selected');
            if (selectedItem.classList.contains('widget-on-canvas') && selectedItem.parentElement) {
                const parent = selectedItem.parentElement;
                // Only re-append if it's not already the last child.
                // This helps maintain z-order for items that are not the selected one,
                // and ensures the selected one is "on top" of siblings by DOM order if z-index is same/absent.
                // This also prevents the "jump" for newly added items.
                if (parent.lastChild !== selectedItem) {
                    parent.appendChild(selectedItem);
                }
            }
            displayItemProperties(selectedItem);
        } else {
            clearPropertiesSidebar();
        }
    };

    const displayItemProperties = (element) => {
        propertiesSidebarContent.innerHTML = ''; 
        const isDialogCanvas = element.id === 'dialog-canvas';
        const properties = JSON.parse(element.dataset.properties);

        const titleText = isDialogCanvas ? `Window Properties` : `Properties: ${properties.type || 'Widget'} (${properties.id})`;
        const title = document.createElement('h4'); // Using h4 for widget title to be smaller than main sidebar title
        title.textContent = titleText;
        propertiesSidebarContent.appendChild(title);

        if (!isDialogCanvas) {
            const removeButton = document.createElement('button');
            removeButton.textContent = 'Remove Widget';
            removeButton.id = 'remove-widget-button'; // Keep the ID for uniqueness
            removeButton.classList.add('remove-widget-button'); // Restore original class for styling
            removeButton.onclick = () => {
                if (selectedItem && selectedItem !== dialogCanvas) {
                    const parentOfSelected = selectedItem.parentElement;
                    selectedItem.remove();
                    // Attempt to select the parent if it's a container, otherwise select dialogCanvas
                    if (parentOfSelected && parentOfSelected.classList.contains('container-widget')) {
                        selectItem(parentOfSelected);
                    } else {
                        selectItem(dialogCanvas);
                    }
                }
            };
            propertiesSidebarContent.appendChild(removeButton);
        }

        // Base properties applicable to most widgets
        const baseEditablePropertiesSpec = {
            text: 'Text',
            x: 'X (px)',
            y: 'Y (px)',
            width: 'Width (px)',
            height: 'Height (px)',
            visible: 'Visible',
            enabled: 'Enabled',
            tooltip: 'Tooltip',
            zindex: 'Z-Index',
            tabOrder: 'Tab Order',
            skinName: 'Skin Name'
        };

        let currentRenderSpec;

        if (isDialogCanvas) {
            currentRenderSpec = {
                text: 'Dialog Title', // 'text' is used for dialog title in its properties
                width: 'Width (px)',
                height: 'Height (px)',
                visible: 'Visible',
                // enabled: 'Enabled', // Usually not directly set for dialog itself in this way
                skinName: 'Skin Name'
            };
        } else {
            currentRenderSpec = { ...baseEditablePropertiesSpec }; // Start with base
            // Add/modify widget-specific properties
            if (properties.type === 'checkbox' || properties.type === 'togglebutton') {
                currentRenderSpec.checked = 'Checked';
            }
            if (properties.type === 'combobox' || properties.type === 'combolist') {
                currentRenderSpec.items = 'Items (comma-sep)';
            }
            if (properties.type === 'combobox') {
                currentRenderSpec.selectedIndex = 'Selected Index (0-based)';
            }
            if (properties.type === 'scrollpane') {
                currentRenderSpec.vertScrollBarStep = 'Vertical Scroll Bar Step';
                currentRenderSpec.horzScrollBarStep = 'Horizontal Scroll Bar Step';
                currentRenderSpec.vertMouseWheel = 'Vertical Mouse Wheel';
                currentRenderSpec.horzMouseWheel = 'Horizontal Mouse Wheel';
            }
            if (properties.type === 'grid') {
                currentRenderSpec.dataSource = 'Data Source (Lua function)';
                currentRenderSpec.rowHeight = 'Row Height (px)';
                currentRenderSpec.columns = 'Columns (JSON)';
                currentRenderSpec.vertScrollBar = 'Vertical ScrollBar';
                currentRenderSpec.horzScrollBar = 'Horizontal ScrollBar';
                currentRenderSpec.useAlternatingRowColor = 'Alt. Row Color';
                currentRenderSpec.selectedAttributeColor = 'Selected Attr Color (hex)';
                currentRenderSpec.selectedRowColor = 'Selected Row Color (hex)';
                currentRenderSpec.altRowColor = 'Alternate Row Color (hex)';
            }
        }

        for (const key in currentRenderSpec) {
            const propContainer = document.createElement('div');
            propContainer.classList.add('property-item');

            const label = document.createElement('label');
            label.setAttribute('for', `prop-${key}-${properties.id}`);
            label.textContent = `${currentRenderSpec[key]}:`;
            propContainer.appendChild(label);

        if (key === 'skinName') {
            const skinLabel = document.createElement('label');
            skinLabel.textContent = 'skinName:';
            const skinInput = document.createElement('input');
            skinInput.type = 'text';
            skinInput.value = properties[key] || '';
            skinInput.addEventListener('change', (e) => {
                properties[key] = e.target.value;
                // Also update skinData.params.name if it exists, to keep them in sync
                if (properties.skinData && properties.skinData.params) {
                    properties.skinData.params.name = e.target.value;
                }
                element.dataset.properties = JSON.stringify(properties);
                // If skin details are shown, update them too
                // if (selectedItem === element && skinDetailsContent.firstChild) { // skinDetailsContent might be undefined now
                //     populateSkinDetailsSidebar(properties.skinData, element);
                // }
            });
            propContainer.appendChild(skinLabel);
            propContainer.appendChild(skinInput);
        } else if (key === 'skinData') {
            // Button to open skin editor / view details - REMOVED
            // const skinDataLabel = document.createElement('label');
            // skinDataLabel.textContent = 'skinData:';
            // const viewSkinButton = document.createElement('button');
            // viewSkinButton.textContent = 'View/Edit Skin Details';
            // viewSkinButton.classList.add('view-skin-button');
            // viewSkinButton.onclick = () => {
            //     populateSkinDetailsSidebar(properties.skinData, element); // populateSkinDetailsSidebar might be undefined or not desired
            // };
            // propContainer.appendChild(skinDataLabel);
            // propContainer.appendChild(viewSkinButton);
            // Instead of the button, perhaps just show the skinData as a non-editable text for now, or nothing.
            // For now, let's not add anything for skinData to simplify.
            continue; // Skip rendering anything for skinData for now
        } else if (typeof properties[key] === 'boolean' || 
            (currentRenderSpec[key] && (currentRenderSpec[key].toLowerCase().includes('visible') || currentRenderSpec[key].toLowerCase().includes('enabled'))) ||
            ['vertMouseWheel', 'horzMouseWheel', 'vertScrollBar', 'horzScrollBar', 'useAlternatingRowColor'].includes(key)) {
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.checked = properties[key] || false;
            checkbox.addEventListener('change', (e) => {
                properties[key] = e.target.checked;
                element.dataset.properties = JSON.stringify(properties);
                // No need to re-select or re-display for checkbox change unless it affects layout
            });
            propContainer.appendChild(checkbox);
        } else {
            let inputType = 'text';
            const propValue = properties[key];

            if (typeof propValue === 'number' && !['zindex', 'tabOrder', 'selectedIndex', 'rowHeight', 'vertScrollBarStep', 'horzScrollBarStep'].includes(key)) {
                // Keep general numbers as text to avoid spinner issues if not strictly integer steps
            } else if (key === 'items' || key === 'tooltip' || key === 'columns' || (key === 'text' && properties.type !== 'editbox' && properties.type !== 'combobox' && properties.type !== 'Dialog')) {
                inputType = 'textarea';
            } else if (['zindex', 'tabOrder', 'selectedIndex', 'rowHeight', 'vertScrollBarStep', 'horzScrollBarStep'].includes(key) || (currentRenderSpec[key] && currentRenderSpec[key].toLowerCase().includes('(px)'))) {
                inputType = 'number';
            }
            
            if (key === 'dataSource' || key === 'selectedAttributeColor' || key === 'selectedRowColor' || key === 'altRowColor') {
                inputType = 'text'; // Ensure these are text, even if they might look like numbers/colors
            }

            const input = document.createElement(inputType === 'textarea' ? 'textarea' : 'input');
            if (inputType !== 'textarea') input.type = inputType;
            
            input.id = `prop-${key}-${properties.id}`;
            input.name = key;
            input.classList.add('property-input'); // Consistent styling

            if (inputType === 'textarea') {
                input.value = properties[key] !== undefined ? properties[key] : '';
                input.rows = 3;
            } else {
                input.value = properties[key] !== undefined ? properties[key] : '';
            }

            input.addEventListener('change', (e) => {
                const currentProps = JSON.parse(element.dataset.properties);
                let value = e.target.value;

                if (input.type === 'number') {
                    value = parseFloat(value);
                    if (isNaN(value)) value = currentProps[key] || ( (key === 'width' || key === 'height') ? 100 : 0 );
                } else if (input.type === 'checkbox') {
                    value = e.target.checked;
                } else if (key === 'items') {
                    value = e.target.value.split(',').map(item => item.trim()).filter(item => item);
                }

                currentProps[key] = value;
                element.dataset.properties = JSON.stringify(currentProps);
                
                if (isDialogCanvas) {
                    if (key === 'width') element.style.width = currentProps[key] + 'px';
                    if (key === 'height') element.style.height = currentProps[key] + 'px';
                } else {
                    if (key === 'text' && element.firstChild && element.firstChild.nodeType === Node.TEXT_NODE) element.firstChild.nodeValue = currentProps[key];
                    if (key === 'x') element.style.left = currentProps[key] + 'px';
                    if (key === 'y') element.style.top = currentProps[key] + 'px';
                    if (key === 'width') element.style.width = currentProps[key] + 'px';
                    if (key === 'height') element.style.height = currentProps[key] + 'px';
                    if (key === 'checked' && properties.type === 'togglebutton') {
                        element.dataset.checked = value; 
                    }
                }
            });
            propContainer.appendChild(input);
        }
        propertiesSidebarContent.appendChild(propContainer);
    }

    // Add 'Edit Skin Details' button for all non-dialogCanvas items
    // Removed this block to ensure only one 'Remove Widget' button exists
    // if (!isDialogCanvas) {
    //     const editSkinButton = document.createElement('button');
    //     editSkinButton.textContent = 'Edit Skin Details';
    //     editSkinButton.id = 'edit-skin-details-button';
    //     editSkinButton.style.marginTop = '10px';
    //     editSkinButton.onclick = () => {
    //         if (selectedItem) {
    //             const currentProps = JSON.parse(selectedItem.dataset.properties);
    //             populateSkinDetailsSidebar(currentProps.skinData, selectedItem);
    //         } else {
    //             clearSkinDetailsSidebar();
    //         }
    //     };
    //     propertiesSidebarContent.appendChild(editSkinButton);
    // }

    // Add Remove Widget button if a widget is selected (not dialog-canvas)
    // Removed this block to ensure only one 'Remove Widget' button exists
    // if (!isDialogCanvas && element) {
    //     const removeButton = document.createElement('button');
    //     removeButton.textContent = 'Remove Widget';
    //     removeButton.classList.add('remove-widget-button'); // For styling
    //     removeButton.addEventListener('click', () => {
    //         if (selectedItem && selectedItem !== dialogCanvas) {
    //             const parentOfSelected = selectedItem.parentElement;
    //             selectedItem.remove();
    //             selectItem(null); // Clear selection and properties
    //             // If the parent was the main dialog canvas, check placeholder
    //             if (parentOfSelected && parentOfSelected.id === 'dialog-canvas') {
    //                 removeCanvasPlaceholder();
    //             }
    //         }
    //     });
    //     propertiesSidebarContent.appendChild(document.createElement('hr')); // Separator
    //     propertiesSidebarContent.appendChild(removeButton);
    // }
    };

    const clearPropertiesSidebar = () => {
        propertiesSidebarContent.innerHTML = '<p>Select an item on the canvas or the canvas itself to see its properties.</p>';
        const placeholder = dialogCanvas.querySelector('.canvas-placeholder');
        if (placeholder) placeholder.textContent = 'Click the canvas to edit dialog properties, or add widgets from the toolbar.';
    };

    const clearSkinDetailsSidebar = () => {
        skinDetailsContent.innerHTML = ''; // Clear previous content
        // Optionally, display a placeholder message
        const placeholder = document.createElement('p');
        placeholder.textContent = 'Select a widget and click "Edit Skin Details" to manage its skin properties.';
        skinDetailsContent.appendChild(placeholder);
    };

    const populateSkinDetailsSidebar = (skinData, widgetElement) => {
        clearSkinDetailsSidebar(); // Clear previous content first
        skinDetailsContent.innerHTML = ''; // Clear placeholder if any

        if (!skinData) {
            skinDetailsContent.textContent = 'No skin data available for this widget.';
            return;
        }

        const widgetProps = JSON.parse(widgetElement.dataset.properties);

        const title = document.createElement('h3');
        title.textContent = `Editing Skin for: ${widgetProps.id}`;
        skinDetailsContent.appendChild(title);

        // --- Edit skinData.params.name --- 
        const paramsNameContainer = document.createElement('div');
        paramsNameContainer.classList.add('property-item');
        const paramsNameLabel = document.createElement('label');
        paramsNameLabel.textContent = 'Skin Params Name (skinData.params.name):';
        const paramsNameInput = document.createElement('input');
        paramsNameInput.type = 'text';
        paramsNameInput.value = skinData.params && skinData.params.name ? skinData.params.name : (widgetProps.skinName || 'defaultSkin');
        
        paramsNameInput.onchange = (e) => {
            const newSkinName = e.target.value;
            const currentWidgetProps = JSON.parse(widgetElement.dataset.properties);
            if (!currentWidgetProps.skinData) currentWidgetProps.skinData = { params: {}, states: {} };
            if (!currentWidgetProps.skinData.params) currentWidgetProps.skinData.params = {};
            
            currentWidgetProps.skinData.params.name = newSkinName;
            currentWidgetProps.skinName = newSkinName; // Keep skinName property in sync
            
            widgetElement.dataset.properties = JSON.stringify(currentWidgetProps);
            // If the main properties sidebar is showing this widget, update its skinName field too
            if (selectedItem === widgetElement) {
                displayItemProperties(widgetElement); // Re-render properties to show updated skinName
            }
        };
        paramsNameContainer.appendChild(paramsNameLabel);
        paramsNameContainer.appendChild(paramsNameInput);
        skinDetailsContent.appendChild(paramsNameContainer);

        // --- Placeholder for states --- 
        const statesTitle = document.createElement('h4');
        statesTitle.textContent = 'Skin States (skinData.states):';
        statesTitle.style.marginTop = '15px';
        skinDetailsContent.appendChild(statesTitle);

        const statesPre = document.createElement('pre');
        statesPre.style.whiteSpace = 'pre-wrap';
        statesPre.style.wordBreak = 'break-all';
        statesPre.textContent = JSON.stringify(skinData.states || {}, null, 2);
        skinDetailsContent.appendChild(statesPre);

        // TODO: Build out the actual form for editing skinData.states
        // (add state, add layer, edit layer properties using textareas for JSON initially)
        // A more robust solution would be a function: objectToLuaTableString(layer)
        // For now, we'll keep the placeholder and preformatted JSON display
    };

    // Widget type mapping for DLG file
    const widgetTypeMap = {
        label: 'Static',
        button: 'Button',
        editbox: 'EditBox',
        checkbox: 'CheckBox',
        togglebutton: 'ToggleButton', // Or 'Button' if DLG uses Button for this
        combobox: 'ComboBox',
        combolist: 'ComboList', // Or 'ComboBox' if DLG uses ComboBox for this
        panel: 'Panel',
        image: 'Image',
        grid: 'Grid',
        gridheadercell: 'GridHeaderCell',
        scrollpane: 'ScrollPane'
    };

    // Function to generate Lua for a single widget and its children
    function generateWidgetLua(widgetElement, indentLevel = 1) {
        const props = JSON.parse(widgetElement.dataset.properties);
        const childIndent = '    '.repeat(indentLevel + 1);

        // Use widgetTypeMap to get the DLG widget type
        const dlgWidgetType = widgetTypeMap[props.type] || (props.type.charAt(0).toUpperCase() + props.type.slice(1));

        // const widgetSkinName = props.skinName || 'defaultSkin'; // Fallback if skinName is missing
        // Prioritize skinData for skin generation
        const skinToUse = props.skinData || { params: { name: props.skinName || 'defaultSkin' }, states: {} };
        if (!skinToUse.params) skinToUse.params = { name: props.skinName || 'defaultSkin' };
        if (!skinToUse.states) skinToUse.states = {};

        let paramsContent = `\n${childIndent}    ["type"] = "${escapeLuaString(dlgWidgetType)}"`;
        
        if (props.text !== undefined && props.type !== 'panel' && props.type !== 'scrollpane' && props.type !== 'treeview' && props.type !== 'grid') { // Grids usually don't have a direct text param in DLG
            paramsContent += `,\n${childIndent}    ["text"] = "${escapeLuaString(props.text)}"`;
        }
        if (props.tooltip !== undefined && props.tooltip !== '') {
            paramsContent += `,\n${childIndent}    ["tooltip"] = "${escapeLuaString(props.tooltip)}"`;
        }
        if (props.type === 'checkbox' || props.type === 'togglebutton') {
            paramsContent += `,\n${childIndent}    ["checked"] = ${props.checked || false}`;
        }
        if (props.type === 'combobox' || props.type === 'combolist') {
            const itemsLua = (props.items && props.items.length > 0) 
                ? props.items.map(item => `\"${escapeLuaString(item)}\"`).join(', ') 
                : '';
            paramsContent += `,\n${childIndent}    ["items"] = { ${itemsLua} }`;
        }
        if (props.type === 'combobox' && props.selectedIndex !== undefined && typeof props.selectedIndex === 'number') {
            paramsContent += `,\n${childIndent}    ["selectedIndex"] = ${props.selectedIndex + 1}`;
        }
        if (props.type === 'scrollpane') {
            paramsContent += `,\n${childIndent}    ["vertScrollBarStep"] = ${props.vertScrollBarStep || 16},` +
                             `\n${childIndent}    ["horzScrollBarStep"] = ${props.horzScrollBarStep || 0},` +
                             `\n${childIndent}    ["vertMouseWheel"] = ${props.vertMouseWheel === undefined ? true : props.vertMouseWheel},` +
                             `\n${childIndent}    ["horzMouseWheel"] = ${props.horzMouseWheel === undefined ? false : props.horzMouseWheel}`;
        }
        if (props.type === 'grid') {
            paramsContent += `,\n${childIndent}    ["dataSource"] = "${escapeLuaString(props.dataSource || '')}",` +
                             `\n${childIndent}    ["rowHeight"] = ${props.rowHeight || 20},` +
                             `\n${childIndent}    ["vertScrollBar"] = ${props.vertScrollBar === undefined ? true : props.vertScrollBar},` +
                             `\n${childIndent}    ["horzScrollBar"] = ${props.horzScrollBar === undefined ? false : props.horzScrollBar},` +
                             `\n${childIndent}    ["selectedAttributeColor"] = "${escapeLuaString(props.selectedAttributeColor || '0x00000000')}",` +
                             `\n${childIndent}    ["selectedRowColor"] = "${escapeLuaString(props.selectedRowColor || '0x87CEEB80')}",` +
                             `\n${childIndent}    ["useAlternatingRowColor"] = ${props.useAlternatingRowColor === undefined ? false : props.useAlternatingRowColor},` +
                             `\n${childIndent}    ["altRowColor"] = "${escapeLuaString(props.altRowColor || '0xF0F0F0FF')}"`;
            // Columns formatting
            try {
                const columnsArray = JSON.parse(props.columns);
                if (Array.isArray(columnsArray)) {
                    const columnsLua = columnsArray.map(col => 
                        `{ [\"align\"] = \"${escapeLuaString(col.align || 'left')}\",` +
                        ` [\"attribute\"] = \"${escapeLuaString(col.attribute || '')}\",` +
                        ` [\"width\"] = ${col.width || 100} }`
                    ).join(', '); 
                    paramsContent += `,\n${childIndent}    [\"columns\"] = { ${columnsLua} }`;
                }
            } catch (e) {
                console.error('Error parsing Grid columns JSON:', e);
                paramsContent += `,\n${childIndent}    [\"columns\"] = {}`; // Default to empty if error
            }
        }

        let skinString = '';
        // Generate skin block based on skinToUse (which prioritizes skinData)
        const skinParamsName = skinToUse.params.name || 'defaultSkin';
        let statesLua = '';

        if (Object.keys(skinToUse.states).length > 0) {
            statesLua = Object.entries(skinToUse.states).map(([stateName, layers]) => {
                const layersLua = layers.map(layer => {
                    // Assuming layer is an object that can be stringified to represent Lua table content
                    // This needs a robust way to convert JS object to Lua table string for each layer
                    // For now, a simplified JSON.stringify might work for basic structures if DCS accepts it, or we need a custom converter.
                    // Let's assume for now each layer is simple like { bkg: { center_center: "0x..." } }
                    // A more robust solution would be a function: objectToLuaTableString(layer)
                    let layerContent = '';
                    if (typeof layer === 'object' && layer !== null) {
                        layerContent = Object.entries(layer).map(([layerKey, layerValue]) => {
                            // Example: { bkg: { center_center: "0xRRGGBBAA" } }
                            // -> ["bkg"] = { ["center_center"] = "0xRRGGBBAA" }
                            if (typeof layerValue === 'object' && layerValue !== null) {
                                const innerContent = Object.entries(layerValue)
                                    .map(([k, v]) => `[\"${escapeLuaString(k)}\"] = \"${escapeLuaString(v)}\"`) // Assumes inner values are strings
                                    .join(', ');
                                return `[\"${escapeLuaString(layerKey)}\"] = { ${innerContent} }`;
                            } else {
                                return `[\"${escapeLuaString(layerKey)}\"] = \"${escapeLuaString(String(layerValue))}\"`;
                            }
                        }).join(', ');
                    }
                    return `{ ${layerContent} }`;
                }).join(',\n' + childIndent + '          '); // Indent subsequent layers
                return `\n${childIndent}      [\"${escapeLuaString(stateName)}\"] = {\n${childIndent}          ${layersLua}\n${childIndent}      }`; 
            }).join(',');
            skinString = `,\n${childIndent}  ["skin"] = {\n${childIndent}    ["params"] = { ["name"] = "${escapeLuaString(skinParamsName)}" },\n${childIndent}    ["states"] = {${statesLua}\n${childIndent}    }\n${childIndent}  }`;
        } else {
            // Fallback to simple skin name if no detailed states
            skinString = `,\n${childIndent}  ["skin"] = {\n${childIndent}    ["params"] = { ["name"] = "${escapeLuaString(skinParamsName)}" },\n${childIndent}    ["states"] = {}\n${childIndent}  }`;
        }


        let childrenStringForTable = '';
        if (['panel', 'scrollpane', 'treeview', 'grid'].includes(props.type)) {
            const childWidgets = Array.from(widgetElement.querySelectorAll(':scope > .widget-on-canvas'));
            if (childWidgets.length > 0) {
                const childrenEntries = childWidgets.map(child => generateWidgetLua(child, indentLevel + 2)); 
                childrenStringForTable = `,\n${childIndent}  ["children"] = {\n${childrenEntries.join(',\n')}\n${childIndent}  }`;
            }
        }
        
        const widgetName = props.id; // Use the unique ID as the widget name in Lua table

        return `${'    '.repeat(indentLevel)}["${escapeLuaString(widgetName)}"] = {` +
               `\n${childIndent}  ["bounds"] = { ${props.x}, ${props.y}, ${props.width}, ${props.height} },` +
               `\n${childIndent}  ["visible"] = ${props.visible === undefined ? true : props.visible},` +
               `\n${childIndent}  ["enabled"] = ${props.enabled === undefined ? true : props.enabled},` +
               `\n${childIndent}  ["tabOrder"] = ${props.tabOrder || 0},` +
               `\n${childIndent}  ["params"] = {${paramsContent}\n${childIndent}  }` +
               `${skinString}` +
               `${childrenStringForTable}\n${'    '.repeat(indentLevel)}}`;
    }

    function generateAndDownloadDlg() {
        const dialogCanvasElement = document.getElementById('dialog-canvas');
        const dialogProps = JSON.parse(dialogCanvasElement.dataset.properties);
        const dialogName = dialogProps.text || "MyDialog";

        const childWidgets = Array.from(dialogCanvasElement.querySelectorAll(':scope > .widget-on-canvas'));
        const childrenContent = childWidgets.length > 0 
            ? childWidgets.map(widget => generateWidgetLua(widget, 2)).join(',') + '\n    ' 
            : '    -- No child widgets\n    ';

        const luaString = `dialog = {\n    ["type"] = "Window",\n    ["params"] = {\n        ["bounds"] = {\n            [1] = { ["h"] = ${dialogProps.height}, ["w"] = ${dialogProps.width}, ["x"] = 0, ["y"] = 0 }\n        },\n        ["draggable"] = true, ["enabled"] = true, ["hasCursor"] = true, ["lockFlow"] = false,\n        ["modal"] = false, ["offscreen"] = false, ["resizable"] = true, ["zOrder"] = 100,\n        ["text"] = "${escapeLuaString(dialogProps.text || 'Dialog')}"\n    },\n    ["skin"] = {\n        ["params"] = { ["name"] = "${escapeLuaString(dialogProps.skinName)}" },\n        ["states"] = { ["released"] = { [1] = { ["bkg"] = { ["center_center"] = "0x000000cc" } } } }\n    },\n    ["children"] = {${childrenContent}}\n};`;

        const blob = new Blob([luaString], { type: 'text/plain;charset=utf-8' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = `${dialogName.replace(/[^a-zA-Z0-9_\-]/g, '_')}.dlg`;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(link.href);

        console.log("DLG file generated:");
        console.log(luaString);
        alert("Dialog saved as " + `${dialogName}.dlg`);
    }

    function makeDraggable(element) {
        let offsetX, offsetY, isDragging = false;

        element.addEventListener('mousedown', (e) => {
            // Select the item on mousedown, before dragging starts
            // This ensures selection even if it's just a click without a drag.
            if (element.classList.contains('widget-on-canvas')) {
                selectItem(element);
            }
            
            // If the event target is an interactive element inside the draggable element, don't drag.
            if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.tagName === 'SELECT' || e.target.tagName === 'BUTTON') {
                return;
            }

            // Only allow dragging if the mousedown occurred directly on this element,
            // not on a child that might also be draggable (unless it's a non-interactive part of this element).
            // For simplicity here, we'll assume if it's not an interactive element (checked above),
            // and it's part of this 'element', this 'element' should be dragged.
            // More complex scenarios might check if e.target.closest('.widget-on-canvas') === element.

            e.preventDefault(); // Prevent text selection and default browser drag behavior.
            e.stopPropagation(); // Crucial: Stop event from bubbling to parent draggable elements.
            
            isDragging = true;

            const rect = element.getBoundingClientRect();
            // offsetX and offsetY are the mouse click's position relative to the dragged element's top-left corner.
            offsetX = e.clientX - rect.left;
            offsetY = e.clientY - rect.top;

            element.style.cursor = 'grabbing';
            element.style.userSelect = 'none'; // Prevent text selection
        });

        document.addEventListener('mousemove', (e) => {
            if (!isDragging) return;

            const dragBoundsContainer = element.parentElement;
            if (!dragBoundsContainer) return; // Should not happen if element is in DOM

            const containerRect = dragBoundsContainer.getBoundingClientRect();
            
            // Calculate the new top-left position of the element relative to its parent container
            let newX = e.clientX - containerRect.left - offsetX;
            let newY = e.clientY - containerRect.top - offsetY;

            // Constrain the element within the parent's bounds
            const elementWidth = element.offsetWidth;
            const elementHeight = element.offsetHeight;
            
            newX = Math.max(0, Math.min(newX, dragBoundsContainer.clientWidth - elementWidth));
            newY = Math.max(0, Math.min(newY, dragBoundsContainer.clientHeight - elementHeight));

            // Snap to grid (optional, e.g., 5px grid)
            // newX = Math.round(newX / 5) * 5;
            // newY = Math.round(newY / 5) * 5;

            element.style.left = `${newX}px`;
            element.style.top = `${newY}px`;

            // Update properties in real-time (optional, can be deferred to mouseup)
            const props = JSON.parse(element.dataset.properties || '{}');
            props.x = newX;
            props.y = newY;
            element.dataset.properties = JSON.stringify(props);
            
            // If properties sidebar is showing this item, refresh it
            if (selectedItem === element) {
                displayItemProperties(element);
            }
        });

        document.addEventListener('mouseup', (e) => {
            if (!isDragging) return;
            isDragging = false;
            element.style.cursor = 'grab';
            element.style.removeProperty('user-select');

            // Final update of properties after drag
            const props = JSON.parse(element.dataset.properties || '{}');
            props.x = parseInt(element.style.left, 10);
            props.y = parseInt(element.style.top, 10);
            element.dataset.properties = JSON.stringify(props);
            
            // If properties sidebar is showing this item, refresh it
            if (selectedItem === element) {
                displayItemProperties(element);
            }
        });

        element.style.cursor = 'grab'; // Initial cursor
    }

    function escapeLuaString(str) {
        if (typeof str !== 'string') return str;
        return str.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\r/g, '\\r');
    }

    // --- Event Listeners & Initial Setup ---
    dialogCanvas.addEventListener('click', (event) => {
        const clickedWidget = event.target.closest('.widget-on-canvas');
        if (clickedWidget) {
            selectItem(clickedWidget);
        } else if (event.target === dialogCanvas) { // Clicked on canvas background
            selectItem(dialogCanvas);
        }
    });

    widgetToolbar.addEventListener('click', (event) => {
        if (event.target.classList.contains('widget-button')) {
            const widgetType = event.target.dataset.widgetType;
            if (widgetType) {
                let parentToAdd = dialogCanvas;
                if (selectedItem && selectedItem !== dialogCanvas && selectedItem.classList.contains('container-widget')) {
                    parentToAdd = selectedItem;
                }
                const newWidgetElement = addWidgetToCanvas(widgetType, parentToAdd);
                // selectItem(newWidgetElement); // addWidgetToCanvas now calls selectItem
            }
        }
    });

    saveDialogButton.addEventListener('click', () => {
        generateAndDownloadDlg();
    });

    clearPropertiesSidebar();
    clearSkinDetailsSidebar(); 
    removeCanvasPlaceholder();
    selectItem(dialogCanvas); 

    // Make all initially present widgets (if any, e.g. from a loaded file in future) draggable
    const initialWidgets = dialogCanvas.querySelectorAll('.widget-on-canvas');
    initialWidgets.forEach(makeDraggable);
});
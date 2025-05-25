document.addEventListener('DOMContentLoaded', () => {
    const widgetToolbar = document.getElementById('widget-toolbar');
    const dialogCanvas = document.getElementById('dialog-canvas');
    const propertiesSidebarContent = document.getElementById('widget-properties-content');
    const skinDetailsContent = document.getElementById('skin-details-content');
    const saveDialogButton = document.getElementById('save-dialog-button');

    let selectedItem = null; 
    let widgetCounter = 0;

    // Resizing state variables
    let isResizing = false;
    let currentResizeHandle = null;
    let initialMouseX, initialMouseY;
    let initialWidgetWidth, initialWidgetHeight;
    let initialWidgetX, initialWidgetY;
    let activeWidgetForResize = null;

    let isDragging = false;
    let dragOffsetX, dragOffsetY;

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

        const defaultSkins = {
            label: "staticSkin",
            button: "buttonSkin",
            checkbox: "checkBoxSkin",
            editbox: "editBoxSkin",
            panel: "panelSkin",
            scrollpane: "scrollPaneSkin",
            combobox: "comboBoxSkin",
            combolist: "comboListSkin",
            togglebutton: "toggleButtonSkin",
            treeview: "treeViewSkin",
            grid: "gridSkin",
            gridheadercell: "gridHeaderCellSkin" // Though typically a child, good to define
        };

        const defaultSkinName = defaultSkins[widgetType] || ""; // Fallback to empty if no default
        
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
        const initialX = 0; // Default X to 0
        const initialY = 0; // Default Y to 0
        
        const commonProps = {
            id: widgetId, // Use the generated widgetId
            parentId: parentElement.id, 
            type: widgetType,
            text: defaultTextContent,
            x: 10,
            y: 10,
            width: initialWidth,
            height: initialHeight,
            visible: true,
            enabled: true,
            tooltip: '',
            zindex: 0, 
            tabOrder: 0,
            skinName: defaultSkinName, // Apply default skinName
            skinData: { // Initialize skinData with the default skinName
                params: { name: defaultSkinName },
                states: {}
            }
        };

        let finalProps; // This will hold the complete properties object

        // Second switch: define the final set of properties for the widget type
        switch (widgetType) {
            case 'label':
                finalProps = { ...commonProps, height: 20, text: 'NewLabel', ...additionalProps };
                break;
            case 'button':
                finalProps = { ...commonProps, ...additionalProps };
                break;
            case 'panel':
            case 'treeview':
                finalProps = { ...commonProps, text: '', ...additionalProps }; // text: '' for panels
                break;
            case 'scrollpane':
                finalProps = {
                    ...commonProps,
                    text: '', // text: '' for scrollpanes
                    vertScrollBarStep: 16,
                    horzScrollBarStep: 0,
                    vertMouseWheel: true,
                    horzMouseWheel: false,
                    ...additionalProps
                };
                break;
            case 'editbox':
                finalProps = { ...commonProps, text: '', ...additionalProps }; // text: '' for editbox
                break;
            case 'checkbox':
                finalProps = { ...commonProps, width: 120, text: 'Checkbox', checked: false, ...additionalProps };
                break;
            case 'togglebutton':
                finalProps = { ...commonProps, width: 120, text: 'ToggleButton', checked: false, ...additionalProps };
                break;
            case 'combobox':
                finalProps = { ...commonProps, width: 150, ...additionalProps }; // items and selectedIndex from additionalProps
                break;
            case 'combolist':
                 finalProps = { ...commonProps, width: 150, text: '', ...additionalProps }; // items from additionalProps, text is usually empty
                 break;
            case 'grid':
                finalProps = {
                    ...commonProps,
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
                finalProps = { ...commonProps, ...additionalProps };
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
            selectedItem.classList.remove('preview-selected');
            // Remove handles from previously selected item, whether it's a widget or dialogCanvas
            removeResizeHandles(selectedItem); 
        }
        selectedItem = element;
        if (selectedItem){
            selectedItem.classList.add('selected');
            selectedItem.classList.add('preview-selected');

            if (selectedItem.id === 'dialog-canvas') {
                addResizeHandles(selectedItem, ['se']); // Only 'se' handle for dialog canvas
            } else if (selectedItem.classList.contains('widget-on-canvas')) {
                addResizeHandles(selectedItem, resizeHandlePositions); // All handles for other widgets
            }

            if (selectedItem.classList.contains('widget-on-canvas') && selectedItem.parentElement) { // This check might be redundant for dialog-canvas but harmless
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

        const titleText = isDialogCanvas ? `Window Properties` : `${properties.type || 'Widget'} (${properties.id})`;
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
            const selectSkin = document.createElement('select');
            selectSkin.id = `prop-${key}-${properties.id}`; // Use the same ID pattern for the select
            selectSkin.classList.add('property-input'); // Use existing class for styling if applicable

            const skinOptions = [
                { value: "", text: "(None/Default)" },
                { value: "windowSkin", text: "windowSkin" }, // Added windowSkin
                { value: "staticSkin", text: "staticSkin" },
                { value: "buttonSkin", text: "buttonSkin" },
                { value: "checkBoxSkin", text: "checkBoxSkin" },
                { value: "editBoxSkin", text: "editBoxSkin" },
                { value: "panelSkin", text: "panelSkin" },
                { value: "comboBoxSkin", text: "comboBoxSkin" },
                { value: "scrollPaneSkin", text: "scrollPaneSkin" },
                { value: "comboListSkin", text: "comboListSkin" },
                { value: "toggleButtonSkin", text: "toggleButtonSkin" },
                { value: "treeViewSkin", text: "treeViewSkin" },
                { value: "gridSkin", text: "gridSkin" }
            ];

            skinOptions.forEach(opt => {
                const option = document.createElement('option');
                option.value = opt.value;
                option.textContent = opt.text;
                selectSkin.appendChild(option);
            });

            selectSkin.value = properties[key] || ''; // Set current value

            selectSkin.addEventListener('change', (e) => {
                properties[key] = e.target.value;
                // Also update skinData.params.name if it exists, to keep them in sync
                // Initialize skinData and skinData.params if they don't exist and a skin is selected
                if (e.target.value) { // If a skin is selected (not empty string)
                    if (!properties.skinData) {
                        properties.skinData = { params: {}, states: {} };
                    }
                    if (!properties.skinData.params) {
                        properties.skinData.params = {};
                    }
                    properties.skinData.params.name = e.target.value;
                } else { // If (None/Default) is selected, clear skinData.params.name or handle as needed
                    if (properties.skinData && properties.skinData.params) {
                        properties.skinData.params.name = ""; // Or consider removing/defaulting skinData
                    }
                }
                element.dataset.properties = JSON.stringify(properties);
                // If skin details are shown, update them too (logic was previously commented out)
                // if (selectedItem === element && typeof populateSkinDetailsSidebar === 'function') {
                //     populateSkinDetailsSidebar(properties.skinData, element);
                // }
            });
            propContainer.appendChild(selectSkin);
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

    const resizeHandlePositions = ['nw', 'ne', 'sw', 'se']; // Default for widgets

    function addResizeHandles(widgetElement, handlesToAdd) {
        removeResizeHandles(widgetElement); // Clear existing handles first
        handlesToAdd.forEach(pos => {
            const handle = document.createElement('div');
            handle.classList.add('resize-handle', pos);
            handle.dataset.position = pos;
            widgetElement.appendChild(handle);
            
            handle.addEventListener('mousedown', (e) => {
                startResize(e, widgetElement, pos);
            });
        });
    }

    function removeResizeHandles(widgetElement) {
        if (widgetElement) {
            const handles = widgetElement.querySelectorAll('.resize-handle');
            handles.forEach(handle => handle.remove());
        }
    }

    function startResize(event, widgetElement, handlePosition) {
        event.preventDefault();
        event.stopPropagation(); // Prevent drag-and-drop from triggering

        isResizing = true;
        currentResizeHandle = handlePosition;
        activeWidgetForResize = widgetElement;

        initialMouseX = event.clientX;
        initialMouseY = event.clientY;

        const widgetRect = widgetElement.getBoundingClientRect();
        const parentRect = widgetElement.parentElement.getBoundingClientRect(); // Assuming parent is the canvas or another container

        initialWidgetWidth = widgetElement.offsetWidth;
        initialWidgetHeight = widgetElement.offsetHeight;
        initialWidgetX = widgetElement.offsetLeft;
        initialWidgetY = widgetElement.offsetTop;
        
        document.addEventListener('mousemove', doResize);
        document.addEventListener('mouseup', stopResize);
    }

    function doResize(event) {
        if (!isResizing || !activeWidgetForResize) return;
        event.preventDefault();

        const dx = event.clientX - initialMouseX;
        const dy = event.clientY - initialMouseY;

        let newWidth = initialWidgetWidth;
        let newHeight = initialWidgetHeight;
        let newX = initialWidgetX; // Only used if not dialogCanvas
        let newY = initialWidgetY; // Only used if not dialogCanvas

        const isDialog = activeWidgetForResize.id === 'dialog-canvas';

        // Adjust dimensions and position based on the handle being dragged
        if (currentResizeHandle.includes('e')) { // East (right)
            newWidth = initialWidgetWidth + dx;
        }
        if (currentResizeHandle.includes('w') && !isDialog) { // West (left) - Not for dialogCanvas
            newWidth = initialWidgetWidth - dx;
            newX = initialWidgetX + dx;
        }
        if (currentResizeHandle.includes('s')) { // South (bottom)
            newHeight = initialWidgetHeight + dy;
        }
        if (currentResizeHandle.includes('n') && !isDialog) { // North (top) - Not for dialogCanvas
            newHeight = initialWidgetHeight - dy;
            newY = initialWidgetY + dy;
        }

        // Ensure minimum size (e.g., 10x10 pixels)
        const minSize = 10;
        if (newWidth < minSize) {
            if (currentResizeHandle.includes('w') && !isDialog) newX -= (minSize - newWidth);
            newWidth = minSize;
        }
        if (newHeight < minSize) {
            if (currentResizeHandle.includes('n') && !isDialog) newY -= (minSize - newHeight);
            newHeight = minSize;
        }

        activeWidgetForResize.style.width = `${newWidth}px`;
        activeWidgetForResize.style.height = `${newHeight}px`;
        
        const properties = JSON.parse(activeWidgetForResize.dataset.properties);
        properties.width = Math.round(newWidth);
        properties.height = Math.round(newHeight);

        if (!isDialog) {
            activeWidgetForResize.style.left = `${newX}px`;
            activeWidgetForResize.style.top = `${newY}px`;
            properties.x = Math.round(newX);
            properties.y = Math.round(newY);
        }
        
        activeWidgetForResize.dataset.properties = JSON.stringify(properties);

        displayItemProperties(activeWidgetForResize); // Refresh sidebar
    }

    function stopResize() {
        if (!isResizing) return;
        isResizing = false;
        document.removeEventListener('mousemove', doResize);
        document.removeEventListener('mouseup', stopResize);
        
        if (activeWidgetForResize) {
            const properties = JSON.parse(activeWidgetForResize.dataset.properties);
            properties.width = parseInt(activeWidgetForResize.style.width, 10);
            properties.height = parseInt(activeWidgetForResize.style.height, 10);
            
            if (activeWidgetForResize.id !== 'dialog-canvas') {
                properties.x = parseInt(activeWidgetForResize.style.left, 10);
                properties.y = parseInt(activeWidgetForResize.style.top, 10);
            }
            activeWidgetForResize.dataset.properties = JSON.stringify(properties);
            displayItemProperties(activeWidgetForResize);
        }

        currentResizeHandle = null;
        activeWidgetForResize = null;
    }

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
        const indentString = '    '.repeat(indentLevel);
        const childPropertyIndent = indentString + '  '; // For type, skin, children, params keys
        const paramsInternalIndent = childPropertyIndent + '  '; // For keys inside the params table

        const dlgWidgetType = widgetTypeMap[props.type] || (props.type.charAt(0).toUpperCase() + props.type.slice(1));

        let widgetPropertiesOutput = []; // Array to hold each line like '["key"] = value' for the main widget table

        // 1. Type (Directly in the widget's table)
        widgetPropertiesOutput.push(`${childPropertyIndent}["type"] = "${escapeLuaString(dlgWidgetType)}"`);

        // 2. Params (Collect all relevant properties for the params table)
        let paramsCollector = [];

        // 2a. Bounds (with named keys, inside params)
        paramsCollector.push(`${paramsInternalIndent}["bounds"] = { ["x"] = ${props.x}, ["y"] = ${props.y}, ["w"] = ${props.width}, ["h"] = ${props.height} }`);
        
        // 2b. Visible (inside params)
        paramsCollector.push(`${paramsInternalIndent}["visible"] = ${props.visible === undefined ? true : props.visible}`);

        // 2c. Enabled (inside params)
        paramsCollector.push(`${paramsInternalIndent}["enabled"] = ${props.enabled === undefined ? true : props.enabled}`);

        // 2d. TabOrder (inside params, using 'tabOrder' as key based on your DLG)
        paramsCollector.push(`${paramsInternalIndent}["tabOrder"] = ${props.tabOrder || 0}`);
        
        // 2e. Text (inside params for all types that might have it)
        if (props.text !== undefined) { // Simplified condition, specific exclusions can be added if truly needed
            paramsCollector.push(`${paramsInternalIndent}["text"] = "${escapeLuaString(props.text)}"`);
        }

        // 2f. Other widget-specific params
        if (props.tooltip !== undefined && props.tooltip !== '') {
            paramsCollector.push(`${paramsInternalIndent}["tooltip"] = "${escapeLuaString(props.tooltip)}"`);
        }
        if (props.type === 'checkbox' || props.type === 'togglebutton') {
            paramsCollector.push(`${paramsInternalIndent}["checked"] = ${props.checked || false}`);
        }
        if (props.type === 'combobox' || props.type === 'combolist') {
            const itemsLua = (props.items && props.items.length > 0)
                ? props.items.map(item => `\"${escapeLuaString(item)}\"`).join(', ')
                : '';
            paramsCollector.push(`${paramsInternalIndent}["items"] = { ${itemsLua} }`);
        }
        if (props.type === 'combobox' && props.selectedIndex !== undefined && typeof props.selectedIndex === 'number') {
            paramsCollector.push(`${paramsInternalIndent}["selectedIndex"] = ${props.selectedIndex + 1}`);
        }
        if (props.type === 'scrollpane') {
            paramsCollector.push(`${paramsInternalIndent}["vertScrollBarStep"] = ${props.vertScrollBarStep || 16}`);
            paramsCollector.push(`${paramsInternalIndent}["horzScrollBarStep"] = ${props.horzScrollBarStep || 0}`);
            paramsCollector.push(`${paramsInternalIndent}["vertMouseWheel"] = ${props.vertMouseWheel === undefined ? true : props.vertMouseWheel}`);
            paramsCollector.push(`${paramsInternalIndent}["horzMouseWheel"] = ${props.horzMouseWheel === undefined ? false : props.horzMouseWheel}`);
        }
        if (props.type === 'grid') {
            paramsCollector.push(`${paramsInternalIndent}["dataSource"] = "${escapeLuaString(props.dataSource || '')}"`);
            paramsCollector.push(`${paramsInternalIndent}["rowHeight"] = ${props.rowHeight || 20}`);
            paramsCollector.push(`${paramsInternalIndent}["columns"] = ${props.columns}`);
            paramsCollector.push(`${paramsInternalIndent}["vertScrollBar"] = ${props.vertScrollBar === undefined ? true : props.vertScrollBar}`);
            paramsCollector.push(`${paramsInternalIndent}["horzScrollBar"] = ${props.horzScrollBar === undefined ? false : props.horzScrollBar}`);
            paramsCollector.push(`${paramsInternalIndent}["selectedAttributeColor"] = "${escapeLuaString(props.selectedAttributeColor || '0x00000000')}"`);
            paramsCollector.push(`${paramsInternalIndent}["selectedRowColor"] = "${escapeLuaString(props.selectedRowColor || '0x87CEEB80')}"`);
            paramsCollector.push(`${paramsInternalIndent}["useAlternatingRowColor"] = ${props.useAlternatingRowColor === undefined ? false : props.useAlternatingRowColor}`);
            paramsCollector.push(`${paramsInternalIndent}["altRowColor"] = "${escapeLuaString(props.altRowColor || '0xF0F0F0FF')}"`);
            try {
                const columnsArray = JSON.parse(props.columns);
                if (Array.isArray(columnsArray)) {
                    const columnsLua = columnsArray.map(col =>
                        `{ [\"align\"] = \"${escapeLuaString(col.align || 'left')}\",` +
                        ` [\"attribute\"] = \"${escapeLuaString(col.attribute || '')}\",` +
                        ` [\"width\"] = ${col.width || 100} }`
                    ).join(', ');
                    paramsCollector.push(`${paramsInternalIndent}["columns"] = { ${columnsLua} }`);
                }
            } catch (e) {
                console.error('Error parsing Grid columns JSON:', e);
                paramsCollector.push(`${paramsInternalIndent}["columns"] = {}`);
            }
        }

        // Add the params table to the main widget properties
        if (paramsCollector.length > 0) {
            widgetPropertiesOutput.push(`${childPropertyIndent}["params"] = {\n${paramsCollector.join(',\n')}\n${childPropertyIndent}}`);
        } else {
            widgetPropertiesOutput.push(`${childPropertyIndent}["params"] = {}`); // Should not happen if bounds, visible etc. are always added
        }

        // 3. Skin (Directly in the widget's table)
        const skinToUse = props.skinData || { params: { name: props.skinName || 'defaultSkin' }, states: {} };
        if (!skinToUse.params) skinToUse.params = { name: props.skinName || 'defaultSkin' };
        if (!skinToUse.states) skinToUse.states = {};
        const skinParamsName = skinToUse.params.name || 'defaultSkin';
        
        const skinDirectIndent = childPropertyIndent + '  '; // Indent for ["params"] and ["states"] keys under ["skin"]
        const skinStatesTableIndent = skinDirectIndent + '  '; 
        const skinLayersArrayIndent = skinStatesTableIndent + '  '; 
        const skinLayerPropsIndent = skinLayersArrayIndent + '  '; 

        let statesLuaString = '';
        if (Object.keys(skinToUse.states).length > 0) {
            const stateEntries = Object.entries(skinToUse.states).map(([stateName, layers]) => {
                const layerEntries = layers.map(layer => {
                    let layerPropsString = '';
                    if (typeof layer === 'object' && layer !== null) {
                        layerPropsString = Object.entries(layer).map(([layerKey, layerValue]) => {
                            if (typeof layerValue === 'object' && layerValue !== null) {
                                const innerPropsString = Object.entries(layerValue)
                                    .map(([k, v]) => `[\"${escapeLuaString(k)}\"] = \"${escapeLuaString(v)}\"`)
                                    .join(', ');
                                return `${skinLayerPropsIndent}[\"${escapeLuaString(layerKey)}\"] = { ${innerPropsString} }`;
                            } else {
                                return `${skinLayerPropsIndent}[\"${escapeLuaString(layerKey)}\"] = \"${escapeLuaString(String(layerValue))}\"`;
                            }
                        }).join(',\n');
                    }
                    return `${skinLayersArrayIndent}{\n${layerPropsString}\n${skinLayersArrayIndent}}`;
                }).join(',\n');
                return `${skinStatesTableIndent}[\"${escapeLuaString(stateName)}\"] = {\n${layerEntries}\n${skinStatesTableIndent}}`;
            }).join(',\n');
            statesLuaString = `\n${stateEntries}\n${skinDirectIndent}`;
        }

        widgetPropertiesOutput.push(`${childPropertyIndent}["skin"] = {\n` +
                                   `${skinDirectIndent}["params"] = { ["name"] = "${escapeLuaString(skinParamsName)}" },\n` +
                                   `${skinDirectIndent}["states"] = {${statesLuaString}}\n` +
                                   `${childPropertyIndent}}`);

        // 4. Children (Directly in the widget's table)
        if (['panel', 'scrollpane', 'treeview', 'grid'].includes(props.type)) {
            const childWidgets = Array.from(widgetElement.querySelectorAll(':scope > .widget-on-canvas'));
            if (childWidgets.length > 0) {
                const childrenEntries = childWidgets.map(child => generateWidgetLua(child, indentLevel + 1)); 
                widgetPropertiesOutput.push(`${childPropertyIndent}["children"] = {\n${childrenEntries.join(',\n')}\n${childPropertyIndent}}`);
            }
        }

        const widgetName = props.id;
        return `${indentString}["${escapeLuaString(widgetName)}"] = {\n${widgetPropertiesOutput.join(',\n')}\n${indentString}}`;
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
            const props = JSON.parse(element.dataset.properties);
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
            const props = JSON.parse(element.dataset.properties);
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
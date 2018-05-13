var sigmoid = '1/(1 + e^(-x))';
var node;

/**
 * Drukowanie wag wszystkich polaczen wejsciowych miedzy neuronami
 */
function printNeuralNetwork(network) {
    if (typeof node !== 'undefined')
    {
        var ctr = 0;

        if (node.innerHTML !== '')
        {
            node.innerHTML += '----<br><br>'
        }

        for (var i = 0; i < network.layers.length; i++)
        {
            for (var j = 0; j < network.layers[i].length; j++)
            {
                node.innerHTML += '<strong>Neuron ' + j + ' of Layer ' + i + '</strong>';

                for (var k = 0; k < network.layers[i][j].w.length; k++)
                {
                    node.innerHTML += '<br> w_' + ctr + ' = ' + network.layers[i][j].w[k]; 
                    ctr++;
                }
                
                node.innerHTML += '<br><br>';
            }
        }
    }
}

/**
 * Inicjalizacja, czyli tworzenie sieci
 */
function initialize(inputSignalsLength) {
    var network         = {
        layerSizes:     [13, 13, 1],
        errors:         [],
        layers:         []
    }
    var numberOfLayers  = network.layerSizes.length;

    for (var i = 0; i < numberOfLayers; i++)
    {
        var layer = [];

        for (var k = 0; k < network.layerSizes[i]; k++)
        {
            var inputsNumber = network.layerSizes[i-1]; 
            var neuron       = {
                w:          [],
                sum:        0,
                normSum:    0,
                bias:       0,
                delta:      0
            };

            if (i === 0)
            {
                inputsNumber = inputSignalsLength;
            }

            /**
             * Dodatkowy, niezalezny sygnal wejsciowy
             */
            neuron.bias = Math.random();

            if (Math.random() < 0.5)
            {
                neuron.bias *= -1;
            }

            /**
             * Wybieranie losowych wartosci wag dla polaczen wejsciowych
             */
            for (var j = 0; j < inputsNumber; j++)
            {
                var rand = Math.random();

                if (Math.random() < 0.5)
                {
                    rand *= -1;
                }

                neuron.w.push(rand);
            }

            layer.push(neuron);
        }

        network.layers.push(layer);
    }

    printNeuralNetwork(network);

    return network;
}

/**
 * Propagacja w przod - obliczanie sum wyjsciowych dla kolejnych warstw
 */
function forwardPropagation(network, input, getOutput = false) {
    var numberOfLayers = network.layers.length;
    var signalsIn = input;

    for (var i = 0; i < numberOfLayers; i++)
    {
        var newSignalsin    = [];
        var layer           = network.layers[i];

        for (var j = 0; j < network.layerSizes[i]; j++)
        {
            var neuron = layer[j];
            neuron.sum = neuron.bias;

            for (var k = 0; k < neuron.w.length; k++)
            {
                neuron.sum += signalsIn[k] * neuron.w[k];
            }

            neuron.normSum = math.eval(sigmoid, {x: neuron.sum});
            newSignalsin.push(neuron.sum);
        }

        signalsIn = newSignalsin;
    }

    if (getOutput)
    {
        return network.layers[numberOfLayers-1][0].normSum;
    }
}

/**
 * Propagacja wsteczna:
 * - obliczanie bledow dla kolejnych warstw
 * - korygowanie (wyznaczanie nowych) wag polaczen
 */
function backwardPropagation(network, input, output)
{
    var eta             = 0.55;
    var numberOfLayers  = network.layers.length;

    for (var i = numberOfLayers-1; i >= 0; i--)
    {
        var layer = network.layers[i];
        //console.log('layer index: ', i)

        for (var j = 0; j < network.layerSizes[i]; j++)
        {
            //console.log( j,  network.layerSizes[i] );
            var neuron = layer[j];

            if (i === numberOfLayers-1)
            {
                neuron.delta = Math.pow((output - network.layers[i][0].normSum), 2);
            }
            else
            {
                var upLayerSize  = network.layerSizes[i+1];
                var upLayer      = network.layers[i+1];
                neuron.delta    = 0;

                /**
                 * Sumowanie bledu dla kazdego neuronu
                 */
                for (var k = 0; k < upLayerSize; k++)
                {
                    neuron.delta += upLayer[k].delta * neuron.normSum;
                }

                neuron.delta *= math.eval(sigmoid, {x: neuron.sum});
            }

            /**
             * Modyfikacja wartosci wag w sieci
             */
            for (var k = 0; k < neuron.w.length; k++)
            {
                //console.log(neuron.w[k]);
                neuron.w[k] += 2 * eta * neuron.delta

                if (i > 0)
                {
                    neuron.w[k] *= network.layers[i-1][k].normSum;
                }
                else
                {
                    neuron.w[k] *= input[k];
                }

                //sconsole.log('--> ', neuron.w[k])
            }

            //console.log(neuron.bias);
            neuron.bias += 2 * eta * neuron.delta
            //console.log('--b->', neuron.bias);
        }
    }

    //printNeuralNetwork(network);
}

window.onload = function() {
    node        = document.getElementById('logs');
    var input   = [[0, 0], [0, 1], [1, 0], [1, 1]];
    var output  = [0, 1, 1, 0];
    var network = initialize(input[0].length);

    for (var i = 0; i < 100; i++)
    {
        for (var k = 0; k < input.length; k++)
        {
            forwardPropagation(network, input[k]); 
            backwardPropagation(network, input[k], output[k]);
        }
    }

    var tIndex = 0;

    node.innerHTML += '<br>----<br>';
    node.innerHTML += '<br><strong>in:</strong> [';

    for (var k = 0; k < input[tIndex].length; k++)
    {
        node.innerHTML += input[tIndex][k];

        if (k < input[tIndex].length-1)
        {
            node.innerHTML += ', ';
        }
    }

    node.innerHTML += ']<br><strong>out:</strong> ' + output[tIndex];
    node.innerHTML += '<br><span style="color: red; font-weight: bold">' 
                    + forwardPropagation(network, input[tIndex], true)
                    + '</span>';
}
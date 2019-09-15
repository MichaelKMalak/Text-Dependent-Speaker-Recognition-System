# Text-Dependent-Speaker-Recognition-System
This repository is a MATLAB code of a simple text-dependent speaker-recognition system. The team implemented two approaches:
1. LPCs averaging
2. MFCC

The code is written by Michael Malak, Ziad Mansour, and Karim Rashidy. It is important to mention that the MFCC code is cloned from [Mike Brook's Voicebox github repository](https://github.com/ImperialCollegeLondon/sap-voicebox). We recommend reading [his documentation](http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html). 

## Introduction and Objective
Speaker recognition aims to identify the person who is making a speech or talking by the use of certain tools and processes. A summary of a typical speaker/speech recognition system is based on four functional stages of processing. The four stages are mainly data acquisition, feature extraction, data modeling and finally the decision based on the previous stages. Meanwhile, speaker verification is the idea of accepting or rejecting a certain identity. In fact, when an unknown voice is being checked/processed, the system compares the features of this identity with the already saved models and tries to find a match for it. This process, however, needs a huge and rich training data set in order to be able to correctly model the characteristics of the speaker’s voice and to be able to cover the phonetic space as much as possible.

## Different Methods Implemented

### 1. Linear Predictive Coefficients (LPC):
As implemented at `Main_Phase1.m`

#### 1.1. Introduction
LPC is a tool used mostly in audio signal processing and speech processing for representing the spectral envelope of a digital signal of speech in compressed form, using the information of a linear predictive model. It is one of the most powerful speech analysis techniques, and one of the most useful methods for encoding good quality speech at a low bit rate and provides extremely accurate estimates of speech parameters.

The advantages of this technique is the ease of construction and the low complexity of the code. In fact, it might take very small time to train and test the samples and have somehow a valid outcome. But on the other hand, the performance compared to other techniques might be low.

#### 1.2. Training
The FRAME_LENGTH parameter is chosen to be 20ms as required. The each .wav file is framed using the functions previously done in the labs, and the energy and the zero-crossings rate is measured which will enable us to get the start and end point of the signal to work with at the end. Here is a block diagram for what generally happens in the LPC method.

![LPC Training Process](https://raw.githubusercontent.com/MichaelKMalak/Text-Dependent-Speaker-Recognition-System/master/src/others/LPC%20train.PNG)

The training is done on [several audio samples](https://github.com/MichaelKMalak/Text-Dependent-Speaker-Recognition-System/tree/master/src/trainingData), the LPCs are calculated for each sample and at the end we calculate the average of this matrix to get the final LPC parameters for this speaker. 

A speaker model contains the average LPCs. Each column represents only one speaker. For instance, in the screenshots below, there are 10 speakers and 15 LPCs.

#### 1.3. Testing
The test is done in a similar way to the training on [different audio samples than of the training](https://github.com/MichaelKMalak/Text-Dependent-Speaker-Recognition-System/tree/master/src/testingData). After finishing those steps, Euclidean distance rule is applied. The Euclidean distance is applied to all the LPCs to all the speakers, and then observing the minimum one. The minimum distance corresponds to the identified speaker which is then represented in the confusion matrix to find the accuracy percentage in the end.

### 2. Mel Frequency Cepstral Coefficients (MFCC):
In sound processing, the Mel-frequency Cepstrum (MFC) is a representation of the shortterm power spectrum of a sound, based on a linear cosine transform of a log power spectrum on a nonlinear Mel scale of frequency.

Mel-frequency cepstral coefficients (MFCCs) are coefficients that collectively make up an MFC. They are derived from a type of cepstral representation of the audio clip (a nonlinear "spectrum-of-aspectrum"). The difference between the cepstrum and the mel-frequency cepstrum is that in the MFC, the frequency bands are equally spaced on the mel scale, which approximates the human auditory system's response more closely than the linearly-spaced frequency bands used in the normal cepstrum. This frequency warping can allow for better representation of sound.

![Mel Frequency](https://raw.githubusercontent.com/MichaelKMalak/Text-Dependent-Speaker-Recognition-System/master/src/others/mel_freq.PNG)

This technique is rather complex but more accurate. Overall, this performance has higher complexity than that of the LPC, but when comparing the ones of the codebook-number 16 with that of 32 it is less complex. So we need to take into considerations the trade-offs before implementing the technique.


![Speaker Model Matrix](https://raw.githubusercontent.com/MichaelKMalak/Text-Dependent-Speaker-Recognition-System/master/src/others/SpeakerModel.PNG)

## Conclusion
To conclude our work, both solutions proposed are of a good performance. However, higher performance of the 32 codebook-number meant that whenever the codebook-number increases the performance increases, however, the complexity also increases.

So to sum up, if performance is a crucial factor in the project, then use MFCC and increase the order and the codebook-number. On the other hand, if the complexity of the code is an important factor then LPC will work well, or otherwise decrease the codebook-number of the MFCC.

For sure, we will never reach a performance as a human ear and there will always be trade-offs between complexity and performance, so it needs a perfect analysis before starting any voice recognition project and decide whether very high performance is needed or just a moderate
performance with moderate complexity can do the job.

In addition, LPC gives us a very good model of the vocal tract and is useful in various speech analysis techniques, but MFCC as mentioned is the most commonly used technique, and with MEL filters which tries to model the human auditory system. So as a final conclusion, the performance in case of VQ using MFCC is higher than LPC.

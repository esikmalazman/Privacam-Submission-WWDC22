# WWDC22-Privacam

## Intro, Example Cases + Data
Humans can now solve complex problems like face detection and person segmentation using rapidly evolving computer vision technologies. The camera on smartphones can be easily accessed by pulling it out of the pocket and recording. People also take advantage of this to engage in illegal behaviour, such as recording in public without permission. For example, in 2019, the Swedish Data Protection Authority fined a school for launching a facial recognition pilot program without obtaining consent from students or the Data Protection Authority.

## Motivation
This project shows how to use face detection to protect others' privacy in public. PrivateCam is a video recorder app that lets you censor someone's face and protect their privacy. Other use cases include crime interviews in which we want to anonymise the witness and protect ourselves from potential crime/threats. So I was inspired to make this app to help other authorities utilise this technology to protect people who have been recording without their consent.

## Technologies used 

- AVFoundation - To develop a custom camera configuration and interface
- UIKit - To design and layout the main user interface in the app
- Vision - To analyse and perform face detection in real-time from a back camera view 
- ReplayKit - To record screen that displays back camera view that shows face detection and allows to save the video it into photos album

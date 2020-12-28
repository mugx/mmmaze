/*
 IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 
 Abstract:
 OpenAL-related support functions.
 */

#include "MXOpenALSupport.h"

typedef ALvoid AL_APIENTRY (*alBufferDataStaticProcPtr) (const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);

ALvoid alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq)
{
  static alBufferDataStaticProcPtr proc = NULL;
  
  if (proc == NULL)
  {
    proc = (alBufferDataStaticProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alBufferDataStatic");
  }
  
  if (proc)
    proc(bid, format, data, size, freq);
  
  return;
}

ALuint MakeOpenALBuffer(CFURLRef inFileURL)
{
  OSStatus error = noErr;
  
  ExtAudioFileRef extRef = NULL;
  error = ExtAudioFileOpenURL(inFileURL, &extRef);
  if (error) { printf("MakeOpenALBuffer: ExtAudioFileOpenURL FAILED, Error = %ld\n", (long)error); goto Exit; }
  
  // Get the audio data format
  AudioStreamBasicDescription	theFileFormat;
  UInt32 thePropertySize = sizeof(theFileFormat);
  error = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileDataFormat, &thePropertySize, &theFileFormat);
  if (error) { printf("MakeOpenALBuffer: ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = %ld\n", (long)error); goto Exit; }
  if (theFileFormat.mChannelsPerFrame > 2)  { printf("MakeOpenALBuffer - Unsupported Format, channel count is greater than stereo\n"); goto Exit; }
  
  // Set the client format to 16 bit signed integer (native-endian) data
  // Maintain the channel count and sample rate of the original source format
  AudioStreamBasicDescription theOutputFormat;
  theOutputFormat.mSampleRate = theFileFormat.mSampleRate;
  theOutputFormat.mChannelsPerFrame = theFileFormat.mChannelsPerFrame;
  theOutputFormat.mFormatID = kAudioFormatLinearPCM;
  theOutputFormat.mBytesPerPacket = 2 * theOutputFormat.mChannelsPerFrame;
  theOutputFormat.mFramesPerPacket = 1;
  theOutputFormat.mBytesPerFrame = 2 * theOutputFormat.mChannelsPerFrame;
  theOutputFormat.mBitsPerChannel = 16;
  theOutputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
  
  // Set the desired client (output) data format
  error = ExtAudioFileSetProperty(extRef, kExtAudioFileProperty_ClientDataFormat, sizeof(theOutputFormat), &theOutputFormat);
  if (error) { printf("MakeOpenALBuffer: ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = %ld\n", (long)error); goto Exit; }
  
  // Get the total frame count
  SInt64 theFileLengthInFrames = 0;
  thePropertySize = sizeof(theFileLengthInFrames);
  error = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileLengthFrames, &thePropertySize, &theFileLengthInFrames);
  if (error) { printf("MakeOpenALBuffer: ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %ld\n", (long)error); goto Exit; }
  
  // Read all the data into memory
  UInt32 dataSize = (UInt32)(theFileLengthInFrames * theOutputFormat.mBytesPerFrame);
  void *data = malloc(dataSize);
  if (data)
  {
    AudioBufferList theDataBuffer;
    theDataBuffer.mNumberBuffers = 1;
    theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
    theDataBuffer.mBuffers[0].mNumberChannels = theOutputFormat.mChannelsPerFrame;
    theDataBuffer.mBuffers[0].mData = data;
    
    error = ExtAudioFileRead(extRef, (UInt32*)&theFileLengthInFrames, &theDataBuffer);
    if (error == noErr) // success
    {
      ALsizei	outSampleRate;
      ALenum outDataFormat;
      ALsizei outDataSize;
      ALuint buffer;
      alGenBuffers(1, &buffer);
      
      outDataSize = (ALsizei)dataSize;
      outDataFormat = (theOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
      outSampleRate = (ALsizei)theOutputFormat.mSampleRate;
      alBufferDataStaticProc(buffer, outDataFormat, data, outDataSize, outSampleRate);
      if (alGetError() != AL_NO_ERROR) { printf("MakeOpenALBuffer: ExtAudioFileRead FAILED, Error = %ld\n", (long)error); goto Exit; }
      return buffer;
    }
    else // failure
    {
      free (data);
      data = NULL; // make sure to return NULL
      printf("MakeOpenALBuffer: ExtAudioFileRead FAILED, Error = %ld\n", (long)error); goto Exit;
    }
  }
  
Exit:
  // Dispose the ExtAudioFileRef, it is no longer needed
  if (extRef) ExtAudioFileDispose(extRef);
  return 0;
}


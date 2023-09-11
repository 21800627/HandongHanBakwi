import './style.css'
import AgoraRTC from 'agora-rtc-sdk-ng'
import AgoraRTM from 'agora-rtm-sdk';
import appid from './appId.js'

const token = null;
const rtcUid =  Math.floor(Math.random() * 2032)
const rtmUid =  String(Math.floor(Math.random() * 2032))

const getRoomId = () => {
    const queryString = window.location.search
    const urlParams = new URLSearchParams(queryString)

    if (urlParams.get('room')){
        return urlParams.get('room').toLowerCase()
    }
}

let roomid = getRoomId() || null
document.getElementById('form').roomname.value = roomid

let audioTracks = {
  localAudioTrack: null,
  remoteAudioTracks: {},
}

let rtcClient;
let rtmClient;
let channel;

let micMuted = true
let avatar = null;



const initRtm = async (name) => {

    rtmClient = AgoraRTM.createInstance(appid)
    await rtmClient.login({'uid':rtmUid, 'token':token})
  
    rtmClient.addOrUpdateLocalUserAttributes({'name':name, 'userRtcUid':rtcUid.toString(), 'userAvatar':avatar})

    channel = rtmClient.createChannel(roomid)
    await channel.join()

    getChannelMembers()

    channel.on('MemberJoined', handleMemberJoined)
    channel.on('MemberLeft', handleMemberLeft)

    window.addEventListener('beforeunload', leaveRtmChannel)
}

let initRtc = async () => {
    rtcClient = AgoraRTC.createClient({mode:'rtc', codec:'vp8'})

    rtcClient.on('user-published', handleUserPublished)
    rtcClient.on('user-left', handleUserLeft)

    await rtcClient.join(appid, roomid, token, rtcUid)

    audioTracks.localAudioTrack = await AgoraRTC.createMicrophoneAudioTrack()
    audioTracks.localAudioTrack.setMuted(micMuted)
    rtcClient.publish(audioTracks.localAudioTrack)

    initVolumeIndicator()
}

let toggleMic = async (e) => {
    if (micMuted){
      e.target.src = 'icons/mic.svg'
      e.target.style.backgroundColor = 'ivory'
      micMuted = false
    }else{
      e.target.src = 'icons/mic-off.svg'
      e.target.style.backgroundColor = 'indianred'
      
      micMuted = true
    }
    audioTracks.localAudioTrack.setMuted(micMuted)
}


let lobbyForm = document.getElementById('form')

const enterRoom = async (e) => {
  e.preventDefault()

  if (!avatar){
    alert('Please select a character...')
    return
  }

  roomid = e.target.roomname.value.toLowerCase();
  window.history.replaceState(null, null, `?room=${roomid}`);

  let displayName = e.target.displayname.value
   
  initRtc()
  initRtm(displayName)

  lobbyForm.style.display = 'none'
  document.getElementById('room-header').style.display = "flex"
  document.getElementById('room-name').innerText = roomid
}


let handleUserPublished = async (user, mediaType) => {
    await rtcClient.subscribe(user, mediaType)

    if(mediaType === 'audio'){
        audioTracks.remoteAudioTracks[user.uid] = [user.audioTrack]
        user.audioTrack.play()
    }
}

let handleUserLeft = async (user) => {
    delete audioTracks.remoteAudioTracks[user.uid]
    // document.getElementById(user.uid).remove()
}

let handleMemberJoined = async (MemberId) => {

    let {name, userRtcUid, userAvatar} = await rtmClient.getUserAttributesByKeys(MemberId, ['name', 'userRtcUid', 'userAvatar'])

    let userWrapper = `<div class = "speaker user-rtc-${userRtcUid}" id = "${MemberId}"> 
    <img src = "${userAvatar}" class = "user-avatar avatar-${userRtcUid}"/>
    <p>${name}</p> 
    </div>`

    document.getElementById('members').insertAdjacentHTML('beforeend', userWrapper)
}

let handleMemberLeft = async (MemberId) => {
    document.getElementById(MemberId).remove()
}

let getChannelMembers = async () => {

    let members = await channel.getMembers()
  
    for(let i = 0; members.length > i; i++){
        let {name, userRtcUid, userAvatar} = await rtmClient.getUserAttributesByKeys(members[i], ['name', 'userRtcUid', 'userAvatar'])

        let userWrapper = `
      <div class="speaker user-rtc-${userRtcUid}" id="${members[i]}">
      <img src = "${userAvatar}" class = "user-avatar avatar-${userRtcUid}"/>    
      <p>${name}</p>
      </div>`
    
      document.getElementById('members').insertAdjacentHTML('beforeend', userWrapper)
    }
}

let initVolumeIndicator = () => {

    AgoraRTC.setParameter('AUDIO_VOLUME_INDICATION_INTERVAL', 200)
    rtcClient.enableAudioVolumeIndicator()

    rtcClient.on('volume-indicator', volumes => {
        //console.log('volumes:', volumes)
        volumes.forEach((volume) => {
            //console.log('VOLUME:', volume.level, 'UID:', volume.uid)
            try{
                let item = document.getElementsByClassName(`avatar-${volume.uid}`)[0]
                if (volume.level >= 50){
                    item.style.borderColor = "#00ff00"
                }
                else {
                    item.style.borderColor = "#fff"
                }
            }
            catch(error){
                //PUT YOUR ERROR HERE
            }
        })
    })
}

let leaveRtmChannel = async () => {
    await channel.leave()
    await rtmClient.logout()
}

let leaveRoom = async () => {
    
    audioTracks.localAudioTrack.stop()
    audioTracks.localAudioTrack.close()
  
    
    rtcClient.unpublish()
    rtcClient.leave()

    leaveRtmChannel()
  
    
    document.getElementById('form').style.display = 'block'
    document.getElementById('room-header').style.display = 'none'
    document.getElementById('members').innerHTML = ''
}
  
lobbyForm.addEventListener('submit', enterRoom) 
document.getElementById('leave-icon').addEventListener('click', leaveRoom)
document.getElementById('mic-icon').addEventListener('click', toggleMic)

const avatars = document.getElementsByClassName('avatar-selection')
for (let i=0; avatars.length > i; i++){
  
    avatars[i].addEventListener('click', ()=> {
      for (let i=0; avatars.length > i; i++){
        avatars[i].style.borderColor = "#fff"
        avatars[i].style.opacity = .5
      }
  
        avatar = avatars[i].src
        avatars[i].style.borderColor = "#00ff00"
        avatars[i].style.opacity = 1
    })
  }
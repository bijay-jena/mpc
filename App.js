import {
  View,
  StyleSheet,
  NativeModules,
  NativeEventEmitter,
  Button,
  TextInput,
  ScrollView,
  SafeAreaView,
} from 'react-native';
import React from 'react';

const CounterEvents = new NativeEventEmitter(NativeModules.Counter);

export default function App() {
  const [msgTxt, setMsgText] = React.useState('');
  const [name, setName] = React.useState('');
  React.useEffect(() => {
    CounterEvents.addListener('msgRcv', result =>
      console.log('Rcvd Message : ', result[0]),
    );

    return () => {
      try {
        CounterEvents.removeAllListeners();
      } catch (e) {}
    };
  }, []);

  // async function increment() {
  //   try {
  //     NativeModules.Counter.increment(val => {
  //       console.info('Count is ' + val);
  //     });
  //   } catch (e) {
  //     console.log(e);
  //   }
  // }

  // async function decrement() {
  //   try {
  //     var res = await NativeModules.Counter.decrement();
  //     console.log(res);
  //   } catch (error) {
  //     console.log(error.message, error.code);
  //   }
  // }

  function setUpDevice() {
    NativeModules.Counter.setUpDevice(name);
  }

  function host() {
    NativeModules.Counter.host();
  }

  function join() {
    NativeModules.Counter.join();
  }

  function sendMsg() {
    NativeModules.Counter.sendMsg(msgTxt);
  }

  return (
    <SafeAreaView>
      <ScrollView>
        <View style={styles.container}>
          <TextInput
            placeholder="Device Name"
            onChangeText={newText => setName(newText)}
            value={name}
          />
          <Button title="Set Up Device" onPress={setUpDevice} />
          <Button title="Host" onPress={host} />
          <Button title="Join" onPress={join} />
          <TextInput
            placeholder="Type your message"
            onChangeText={newText => setMsgText(newText)}
            value={msgTxt}
          />
          <Button title="Send" onPress={sendMsg} />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    height: 500,
  },
});

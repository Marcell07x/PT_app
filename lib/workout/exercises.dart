class Exercises {
    // From level 90 the workout runs on push[pushe + 1] rather than letting the
    // reps climb past 15, and workout B steps up from there, so the ladder is
    // read as far as push[pushe + 3].
    Map<int, Map<String, String>> push = {
        1: {
            'videoPath': 'assets/videos/wallPush.mp4',
            'nameKey': 'wallPush',
            'descriptionKey': 'wallPushDesc',
            'reps': ''
        },
        2: {
            'videoPath': 'assets/videos/tablePush.mp4',
            'nameKey': 'tablePush',
            'descriptionKey': 'tablePushDesc',
            'reps': ''
        },
        3: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'diamondTablePush',
            'descriptionKey': 'diamondTablePushDesc',
            'reps': ''
        },
        4: {
            'videoPath': 'assets/videos/kneePush.mp4',
            'nameKey': 'kneePush',
            'descriptionKey': 'kneePushDesc',
            'reps': ''
        },
        5: {
            'videoPath': 'assets/videos/pushUp.mp4',
            'nameKey': 'pushUp',
            'descriptionKey': 'pushUpDesc',
            'reps': ''
        },
        6: {
            'videoPath': 'assets/videos/declinePush.mp4',
            'nameKey': 'declinePush',
            'descriptionKey': 'declinePushDesc',
            'reps': ''
        },
        7: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'explosivePush',
            'descriptionKey': 'explosivePushDesc',
            'reps': ''
        },
        8: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'pseudoPush',
            'descriptionKey': 'pseudoPushDesc',
            'reps': ''
        },
        9: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'dipPush',
            'descriptionKey': 'dipPushDesc',
            'reps': ''
        },
    };

    Map<int, Map<String, String>> pull = {
        1: {
            'videoPath': 'assets/videos/bagPull.mp4',
            'nameKey': 'bagPull',
            'descriptionKey': 'bagPullDesc',
            'reps': ''
        },
        2: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'reverseSnowAngel',
            'descriptionKey': 'reverseSnowAngelDesc',
            'reps': ''
        },
        3: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'bwPull',
            'descriptionKey': 'bwPullDesc',
            'reps': ''
        },
        4: {
            'videoPath': 'assets/videos/pullup.mp4',
            'nameKey': 'pullup',
            'descriptionKey': 'pullupDesc',
            'reps': ''
        },
    };

    // Three leg families sit next to each other at every level: squat, lunge,
    // glute. One full level step is therefore 3 indices, and the workout's
    // variation is the leg switch's offset from the level's base index.
    Map<int, Map<String, String>> legs = {
        1: {
            'videoPath': 'assets/videos/squat1.mp4',
            'nameKey': 'squat1',
            'descriptionKey': 'squat1Desc',
            'reps': ''
        },
        2: {
            'videoPath': 'assets/videos/lunge1.mp4',
            'nameKey': 'lunge1',
            'descriptionKey': 'lunge1Desc',
            'reps': ''
        },
        3: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'glute1',
            'descriptionKey': 'glute1Desc',
            'reps': ''
        },
        4: {
            'videoPath': 'assets/videos/squat2.mp4',
            'nameKey': 'squat2',
            'descriptionKey': 'squat2Desc',
            'reps': ''
        },
        5: {
            'videoPath': 'assets/videos/lunge2.mp4',
            'nameKey': 'lunge2',
            'descriptionKey': 'lunge2Desc',
            'reps': ''
        },
        6: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'glute2',
            'descriptionKey': 'glute2Desc',
            'reps': ''
        },
        7: {
            'videoPath': 'assets/videos/squat3.mp4',
            'nameKey': 'squat3',
            'descriptionKey': 'squat3Desc',
            'reps': ''
        },
        8: {
            'videoPath': 'assets/videos/lunge3.mp4',
            'nameKey': 'lunge3',
            'descriptionKey': 'lunge3Desc',
            'reps': ''
        },
        9: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'glute3',
            'descriptionKey': 'glute3Desc',
            'reps': ''
        },
        10: {
            'videoPath': 'assets/videos/squat4.mp4',
            'nameKey': 'squat4',
            'descriptionKey': 'squat4Desc',
            'reps': ''
        },
        11: {
            'videoPath': 'assets/videos/lunge4.mp4',
            'nameKey': 'lunge4',
            'descriptionKey': 'lunge4Desc',
            'reps': ''
        },
        12: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'glute4',
            'descriptionKey': 'glute4Desc',
            'reps': ''
        },
        13: {
            'videoPath': 'assets/videos/squat5.mp4',
            'nameKey': 'squat5',
            'descriptionKey': 'squat5Desc',
            'reps': ''
        },
        14: {
            'videoPath': 'assets/videos/lunge5.mp4',
            'nameKey': 'lunge5',
            'descriptionKey': 'lunge5Desc',
            'reps': ''
        },
        15: {
            'videoPath': 'assets/videos/test1.mp4',
            'nameKey': 'glute5',
            'descriptionKey': 'glute5Desc',
            'reps': ''
        },
    };

    Map<int, Map<String, String>> core = {
        1: {
            'videoPath': 'assets/videos/core1.mp4',
            'nameKey': 'core1',
            'descriptionKey': 'core1Desc',
            'reps': ''
        },
        2: {
            'videoPath': 'assets/videos/core2.mp4',
            'nameKey': 'core2',
            'descriptionKey': 'core2Desc',
            'reps': ''
        },
    };

    Map<int, Map<String, String>> warmUpExer = {
        1: {
            'videoPath': 'assets/videos/bagPull.mp4',
            'nameKey': 'lightBagPull',
        },
        2: {
            'videoPath': 'assets/videos/runInPlace.mp4',
            'nameKey': 'runInPlace',
        },
    };
}
import os
import re
import lxml.etree as ET

# Путь к папке с ванильными файлами игры
lib = r'F:\Darth Vader\Desktop\EaW export\FoC'
# Путь к папке с модом
mod = r'C:\Program Files (x86)\Steam\steamapps\common\Star Wars Empire at War\corruption\Mods\ROTE\Data'


class BColors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[33m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def search_in_xml(xml_path, extensions: list) -> dict:
    result = {}
    for path, dirs, xml_files in os.walk(xml_path):
        if path == xml_path:
            print(f'Parsing xml in {path}...')
        else:
            print(f'Parsing xml in {path.replace(xml_path, "")}...')
        for xml_file in xml_files:
            if xml_file.endswith('.xml'):
                try:
                    parser = ET.XMLParser(remove_comments=True)
                    file_xml_tree = ET.parse(os.path.join(path, xml_file), parser=parser)
                except Exception:
                    parser = ET.XMLParser(encoding='cp1252', recover=True, remove_comments=True)
                    file_xml_tree = ET.parse(os.path.join(path, xml_file), parser=parser)
                if file_xml_tree.getroot() is None:
                    print(
                        BColors.FAIL + 'XML syntax error in file ' + BColors.ENDC +
                        xml_file +
                        BColors.FAIL + '!' + BColors.ENDC
                    )
                    continue
                for tag in file_xml_tree.iter():
                    if not len(tag):
                        line = str(tag.text).lower()
                        for extension in extensions:
                            if f'.{extension}' in line:
                                if line.count(f'.{extension}') > 1 or ',' in line:
                                    pre_ext = re.compile(fr'(\w[\w\-]+?\.(?:{extension}))')
                                    for match in re.finditer(pre_ext, line):
                                        ext_file = str.lower(match[0])
                                        if ext_file in result:
                                            if xml_file not in result[ext_file]:
                                                result[ext_file].append(xml_file.lower())
                                        else:
                                            result[ext_file] = [xml_file]
                                else:
                                    ext_file = line.strip()
                                    if ext_file in result:
                                        if xml_file not in result[ext_file]:
                                            result[ext_file].append(xml_file.lower())
                                    else:
                                        result[ext_file] = [xml_file]
    print('Done!')
    return result


def search_in_alo(path) -> (dict, dict):
    print(f'Parsing alo in {path}...')
    result_textures = {}
    result_particles = {}
    pre_model_proxy = re.compile(br'(\x00\x00\x03\x06.{8}([\w\-]*?)(_ALT\d)?\x00\x06\x04)')
    pre_model_tex = re.compile(br'(\x00\x02.([\w\-]*?\.\w{3})\x00)')
    pre_particle_tex = re.compile(br'(\x03\x00\x00\x00.\x00\x00\x00([\w\-]*?\.\w{3})(\x00\x16\x00\x00|\x00\x00\x07\x00|\x00\x02\x00\x00))')
    for alo_file_ in os.listdir(path):
        alo_file = str.lower(alo_file_)
        if alo_file.endswith('.alo'):
            # print(alo_file)
            alo_file_content = open(f'{path}\\{alo_file}', mode='rb').read()
            if alo_file_content[0:4] == b'\x00\x02\x00\x00':
                # print('\tModel')
                for match in re.finditer(pre_model_proxy, alo_file_content):
                    # print(match[2])
                    particle_file = match[2].decode('utf8').lower()
                    if particle_file in result_particles:
                        if alo_file not in result_particles[particle_file]:
                            result_particles[particle_file].append(alo_file)
                    else:
                        result_particles[particle_file] = [alo_file]
                for match in re.finditer(pre_model_tex, alo_file_content):
                    # print(match[2])
                    texture_file = match[2].decode('utf8').lower()
                    if texture_file in result_textures:
                        if alo_file not in result_textures[texture_file]:
                            result_textures[texture_file].append(alo_file)
                    else:
                        result_textures[texture_file] = [alo_file]
            elif alo_file_content[0:4] == b'\x00\x09\x00\x00':
                # print('\tParticle')
                for match in re.finditer(pre_particle_tex, alo_file_content):
                    # print(match[2])
                    texture_file = match[2].decode('utf8').lower()
                    if texture_file in result_textures:
                        if alo_file not in result_textures[texture_file]:
                            result_textures[texture_file].append(alo_file)
                    else:
                        result_textures[texture_file] = [alo_file]
            else:
                print(f'WARNING! Unknown alo type: {alo_file}')
    print('Done!')
    return result_textures, result_particles


def search_in_ted(path) -> dict:
    print(f'Parsing ted in {path}...')
    pre_ted_tex = re.compile(br'\x0c[\x00-\xFF]([\x20-\x7E]*?)\x00\x13[\x00-\xFF]([\x20-\x7E]*?)\x00\x12\x01(?:[\x00-\xFF]{73})')
    result = {}

    for ted_file_ in os.listdir(path):
        ted_file = str.lower(ted_file_)
        if ted_file.endswith('.ted'):
            # print(ted_file)
            # if ted_file not in result:
            #     result[ted_file] = []
            ted_file_content = open(f'{path}\\{ted_file}', mode='rb').read()
            n = 0
            for match in re.finditer(pre_ted_tex, ted_file_content):
                texture_file = match[1].decode('utf8').lower()
                normal_file = match[2].decode('utf8').lower()
                n += 1
                # print('\t', n, texture_file, normal_file)
                if texture_file != '':
                    if texture_file not in result:
                        result[texture_file] = [ted_file]
                    else:
                        result[texture_file].append(ted_file)
                if normal_file != '':
                    if normal_file not in result:
                        result[normal_file] = [ted_file]
                    else:
                        result[normal_file].append(ted_file)
    print('Done!')
    return result


# def validate_found_files(path, ext, dict1, dict2):
#     dict_val = {}
#     for file_to_val_ in os.listdir(path):
#         file_to_val = str.lower(file_to_val_)
#         if file_to_val.endswith(ext):
#             status = 'Unused?'
#             if str.lower(file_to_val) in dict1:
#                 status = 'Vanilla'
#             elif file_to_val in dict2:
#                 status = 'Mod'
#             dict_val[str.lower(file_to_val)] = status
#     return dict_val


# Find all alo files, mentioned in xml's
vanilla_alo = search_in_xml(f'{lib}\\Xml', ['alo'])
mod_alo = search_in_xml(f'{mod}\\Xml', ['alo'])

# Find all texture and particle file mentions in alo files
vanilla_textures, vanilla_particles = search_in_alo(f'{lib}\\Art\\Models')
mod_textures, mod_particles = search_in_alo(f'{mod}\\Art\\Models')

# Find all texture file mentions in ted (map) files
vanilla_map_textures = search_in_ted(f'{lib}\\Art\\Maps')
mod_map_textures = search_in_ted(f'{mod}\\Art\\Maps')


def validate_found_files(path_lib, path, ext) -> None:
    global vanilla_alo
    global mod_alo
    global vanilla_particles
    global mod_particles
    global vanilla_textures
    global vanilla_map_textures
    global mod_textures
    global mod_map_textures
    result = {}
    for file_ in os.listdir(path):
        file = str.lower(file_)
        status = 'Unused?'
        usage = []
        if ext == 'alo':
            if file.endswith(f'.{ext}'):
                file_content = open(f'{path}\\{file_}', mode='rb').read()
                if file_content[0:4] == b'\x00\x02\x00\x00':
                    if file in vanilla_alo.keys():
                        status = 'Vanilla'
                    if file in mod_alo.keys():
                        status = 'Mod'
                        usage = mod_alo[file]
                elif file_content[0:4] == b'\x00\x09\x00\x00':
                    p_file = file[:-4]
                    if p_file in vanilla_particles.keys():
                        status = 'Vanilla'
                    if file in vanilla_alo.keys():
                        status = 'Vanilla'
                    if p_file in mod_particles.keys():
                        status = 'Mod'
                        usage += mod_particles[p_file]
                    if file in mod_alo.keys():
                        status = 'Mod'
                        usage += mod_alo[file]
                result[file] = {'status': status, 'usage': usage}
        else:
            file_tga = file.replace('.dds', '.tga')
            if (
                    file in vanilla_textures.keys() or
                    file in vanilla_map_textures.keys()
            ):
                status = 'Vanilla'
            if '.tga' not in file and (
                    file_tga in vanilla_textures.keys() or
                    file_tga in vanilla_map_textures.keys()
            ):
                status = 'Vanilla (tga)'
            if file in mod_textures.keys():
                status = 'Mod'
                usage = mod_textures[file]
            if '.tga' not in file and file_tga in mod_textures.keys():
                status = 'Mod (tga)'
                usage = mod_textures[file_tga]
            if file in mod_map_textures.keys():
                status = 'Mod'
                usage = mod_map_textures[file]
            if '.tga' not in file and file_tga in mod_map_textures.keys():
                status = 'Mod (tga)'
                usage = mod_map_textures[file_tga]
            result[file] = {'status': status, 'usage': usage}

    vanilla = []
    for file in os.listdir(path_lib):
        file = str.lower(file)
        if file.endswith(f'.{ext}'):
            vanilla.append(file)

    missing = {}
    if ext == 'alo':
        to_check = {**mod_alo, **mod_particles}
    else:
        to_check = {**mod_textures, **mod_map_textures}
    for file, usage in to_check.items():
        if ext == 'alo':
            if file not in result.keys() and file not in vanilla:
                missing[file] = {'name': file, 'status': 'Missing', 'usage': usage}
        else:
            file_dds = file
            if 'tga' in file:
                file_dds = file.replace('.tga', '.dds')
            elif '.' not in file:
                file_dds = file + '.dds'
            if file not in result.keys() and file not in vanilla:
                if not (file_dds in result.keys() or file_dds in vanilla):
                    missing[file] = {'name': file, 'status': 'Missing', 'usage': usage}


    report = open(f'{mod}\\check_{ext}_v3.txt', 'w')
    for file, params in result.items():
        report.write(f'{file}\t{params["status"]}\t{params["usage"]}\n')
        # for xml in params["usage"]:
        #     result_alo.write(f'{xml}, ')
        # result_alo.write('\n')
    for file, params in missing.items():
        report.write(f'{file}\t{params["status"]}\t{params["usage"]}\n')
        # for xml in params["usage"]:
        #     result_alo.write(f'{xml}, ')
        # result_alo.write('\n')
    report.close()
    return None


validate_found_files(f'{lib}\\Art\\Models', f'{mod}\\Art\\Models', 'alo')
validate_found_files(f'{lib}\\Art\\Textures', f'{mod}\\Art\\Textures', 'dds')
